Backups
=======

Overview
--------

The intent of the backups is to simply backup the state of the machine, and not the actual machine itself.
The backup scripts write a copy of the state to the /mnt/backup directory.
The contents of this directory are then encrypted and written to Swift.

If so desired, these backups can be downloaded from Swift to an off site location.

A daily backup run is performed.

Any daily backup on the machine (apart from the MySQL backups) that is older than seven days is deleted.

The first backup on Swift is a full one. For the next six days the subsequent backups are incremental. Then another
full backup is performed.

All backup files older than a month are purged from Swift. This means that the furthest a restore can go is a month
back in time. If a complete history is required then a monthly copy of the backups in Swift should be kept as well.

Implementation
==============

There are a number of scripts that run to create the backups. They are chained together and called by the
automysqlbackup package as part of its run.

The /mnt/backup directory contains the following subdirectories:

| Directory   | Contents |
| ----------- | -------- |
| ldap        | The files required to restore the ldap system |
| $(hostname) | The hubzero.secrets file for the machine being backed up |
| mysql       | The mysql database files |
| sites       | The apache files used to serve up the application |
| users       | The files required to restore the users |

Restoring
=========

First
-----

Rebuild a new machine using the scripts in this project.

Note that all of the following is done in the root user role.

Then before doing a restore on a newly rebuilt machine, stop apache from running

```bash
service apache2 stop
```

Fetch the backup
----------------

The backup needs to be fetched from the object store.

To do this you need to set up the environment variables required to access the Swift repository.

This can be done by placing them in a file and then sourcing it. The file is of the following format:

```bash
#!/bin/bash

export SWIFT_USERNAME="<tenancy_name>:<user_id>"
export SWIFT_PASSWORD="<user_password>"
export SWIFT_AUTHURL="https://keystone.rc.nectar.org.au:5000/v2.0/"
export SWIFT_AUTHVERSION="2"
export PASSPHRASE="<pass_phrase_used_to_encrypt_swift_files>"
```

Once the file is sourced, then use duplicity to fetch the file onto the machine from which the restore is being done:

```bash
swift://<source_bucket> <target_directory>
```

Databases
---------

The [automysqlbackup](https://packages.debian.org/search?keywords=automysqlbackup) package is used to backup
the mysql databases.

The location of the backup directory is set in the configuration file `/etc/default/automysqlbackup`. This
configuration file is copied across from the `automysqlbackup.sh` file in the v3 module (the backups manifest
does the dirty work).

So if you want to make any changes to automysqlbackup change the configuration in the `automysqlbackup.sh` file.

Although we currently backup the `information_schema` database, it's a read only one that you can't restore.

automysqlbackup uses the mysqldump command: so databases are locked while the database is being backed up. This
could become a problem if our hubs ever become high traffic websites with large databases. Until then it should
suffice.

automysqlbackup sets up a daily cron job to run the backup. Thus the time the backup is performed is dependent on
when the daily cron job is configured to run.
g
To restore a database, first identify the database you want to restore in the backup directory.

eg:

```bash
ls /mnt/backup/mysqlbackup/daily/example/
example_2015-02-04_03h43m.Wednesday.sql.gz
```

The `.gz` extension shows that the backup is compressed.

To restore it you first need to uncompress it:

```bash
gunzip /mnt/backup/mysqlbackup/daily/example/example_2015-02-04_03h43m.Wednesday.sql.gz
```

Once uncompressed, restore it as follows:

```bash
mysql -h localhost -u root example < /mnt/backup/mysqlbackup/daily/example/example_2015-02-04_03h43m.Wednesday.sql
```

You will need to restore **both** the example and the example_metrics databases.

LDAP
----

The script /etc/ldapbackup is called by automysqlbackup in its post backup phase to backup the ldap database.

To restore the ldap database:

```bash
# First you need to configure slapd to match the domain that you are restoring from, if you are restoring to a new
# machine with a different name.
# If doing this step, use the ldap administrator password (LDAP-ADMINPW) taken from the hubzero.secrets file
# of the machine that you restoring from.
# Also note that if you are restoring from a machine named collaboration.rc.edu.au the domain name
# to enter is rc.edu.au ...
dpkg-reconfigure slapd

# then you need to uncompress your chosen database
tar -zxvf /mnt/backup/ldap/ldap-150204-0522.ldif.gz -C /

# stop the various ldap daemons from running
service nscd stop
service nslcd stop
/etc/init.d/slapd stop

# delete the existing database
pushd /var/lib/ldap
rm -rf *
popd

#I had to do the following as well when restoring the gvl
rm -r /etc/ldap/slapd.d/
mkdir /etc/ldap/slapd.d/

# restore the databases from your selected backup
slapadd -F /etc/ldap/slapd.d -n 0 -l /mnt/backup/ldap/scratch/config.ldif
slapadd -F /etc/ldap/slapd.d -n 1 -l /mnt/backup/ldap/scratch/collaboration.rc.edu.au.ldif

# change the ownership of the restored files back to the slapd user and group
chown -R openldap:openldap /var/lib/ldap
chown -R openldap:openldap /etc/ldap

#copy the nslcd.conf file across to the new machine
cp /mnt/backup/ldap/scratch/nslcd.conf /etc

# start the daemons again
/etc/init.d/slapd start
service nslcd start
service nscd start
```

You can test the restore by trying to set your admin's password to what it was on the machine you were restoring from.
Of course this means that you are setting the password to what it was before you changed it...
e.g.:

```
#example 1
ldappasswd -D "cn=admin,dc=<domain>,dc=edu,dc=au" -s <a_password> -w <a_password>
#example 2
ldappasswd -D "cn=admin,dc=<domain>,dc=org,dc=au " -s <a_password> -w <a_password>
```

To search:

```bash
ldapsearch -x -LLL -b dc=<domain>,dc=edu,dc=au 'uid=hubrepo' cn gidNumber
```

To check that the ldap restore has gone successfully:

```bash
# following should return an ldap user...
getent passwd | grep apps
```

Sites
-----

The script /etc/sitebackup is called by automysqlbackup in its post backup phase to backup the web sites and their
support directories.

To restore the websites, simply remove any crud that might be in the existing /var/www directory, then:

```bash
# uncompress your chosen backup file
tar -zxvf /mnt/backup/sites/sites-150205-0358.tar.gz -C /
```

where sites-150205-0358.tar.gz is the name of the file that you are restoring...

You also need to restore the /srv/ directory:

```bash
# uncompress your chosen backup file
tar -zxvf /mnt/backup/srv/srv-150205-0358.tar.gz -C /
```

where srv-150205-0358.tar.gz is the name of the file that you are restoring...

And the webdav directory:

```bash
# uncompress your chosen backup file
tar -zxvf /mnt/backup/webdav/webdav-150205-0358.tar.gz -C /
```

where webdav-150205-0358.tar.gz is the name of the file that you are restoring...

Users
-----

The script /etc/userbackup is called by automysqlbackup in its post backup phase to backup the web sites.

To restore the users *on a new instance*:

```bash
# you first need to uncompress your chosen user backup file
 tar -zxvf /mnt/backup/users/users-150204-2306.tar.gz -C /

# restore the copied files
cat /mnt/backup/users/scratch/passwd.mig >> /etc/passwd
cat /mnt/backup/users/scratch/group.mig >> /etc/group
cat /mnt/backup/users/scratch/shadow.mig >> /etc/shadow
cp /mnt/backup/users/scratch/gshadow.mig /etc/gshadow

# restore the home directories
tar -zxvf /mnt/backup/users/scratch/home.tar.gz -C /

# restore the mail files
tar -zxvf /mnt/backup/users/scratch/mail.tar.gz -C /

```

Because the install scripts create users, and the restore scripts concatenates users, there may be some duplicate
entries. To check for this & to fix any such errors run:

```bash
grpck
```

Update Passwords
----------------

Update the example users database password in the mysql database
(this is the password for the user named HUBDB in the file named hubzero.secrets
taken off of the machine that you are restoring from):

```
mysql -h localhost -u root -e "SET PASSWORD FOR 'example'@'localhost' = PASSWORD('new_password');"
```

Not necessary, but hand to compare passwords between machines:
```
mysql -h localhost -u root -e "select host, user, password from mysql.user;"
```

Finally
-------

After doing a restore on a newly rebuilt machine, reboot.

```bash
reboot
```


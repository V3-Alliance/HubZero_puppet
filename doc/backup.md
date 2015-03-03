Backups
=======

There are a number of scripts that run to create the backups. They are chained together and called by the
automysqlbackup package as part of its run.

The intent is to simply backup the state of the machine, and not the actual machine itself. The backup scripts
write a copy of the state to the /mnt/backup directory. The contents of this directory are then encrypted and
written to Swift. If so desired, these backups can be downloaded from Swift to an off site location.

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

You will need to restore both the example and the example_metrics databases.

LDAP
----

The script /etc/ldapbackup is called by automysqlbackup in its post backup phase to backup the ldap database.

To restore the ldap database:

```bash
# first you need to configure slapd to match the domain that you are restoring from, if you are restoring to a new
# machine with a different name.
# If doing this step, use the ldap administrator password from the machine that you restoring from...
dpkg-reconfigure slapd

# then you need to uncompress your chosen database
gunzip /mnt/backup/ldap/ldap-150204-0522.ldif.gz

# stop slapd from running
/etc/init.d/slapd stop

# delete the existing database
cd /var/lib/ldap
rm -rf *

# restore the database from your selected backup
/usr/sbin/slapadd -l /mnt/backup/ldap/ldap-150204-0522.ldif

# change the ownership of the restored files back to the slapd user and group
chown -R openldap:openldap /var/lib/ldap

# start the slapd again
/etc/init.d/slapd start
```

You can test the restore by trying to set your admin's password to what it was on the machine you were restoring from.
Of course this means that you are setting the password to what it was before you changed it...
e.g.:

```
#example 1
ldappasswd -D "cn=admin,dc=rc,dc=edu,dc=au" -s <a_password> -w <a_password>
#example 2
ldappasswd -D "cn=admin,dc=v3apps,dc=org,dc=au " -s <a_password> -w <a_password>
```

Sites
-----

The script /etc/sitebackup is called by automysqlbackup in its post backup phase to backup the web sites.

To restore the websites, simply remove any crud that might be in the existing /var/www directory, then:

```bash
# uncompress your chosen backup file
tar -zxvf /mnt/backup/sites/sites-150205-0358.tar.gz -C /
```

where sites-150205-0358.tar.gz is the name of the file that you are restoring...

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
# tar -zxvf /mnt/backup/users/scratch/mail.tar.gz -C /

# and then reboot
reboot
```

Update Passwords
----------------

Update the example users database password in the mysql database:

```
mysql -h localhost -u root -e "SET PASSWORD FOR 'example'@'localhost' = PASSWORD('new_password');"
```

where the new_password is the HUBDB password in the old sites hubzero.secrets file.

To see the passwords:

```
mysql -h localhost -u root -e "select host, user, password from mysql.user;"
```

Finally
-------

After doing a restore on a newly rebuilt machine, remember to restart apache.


```bash
service apache2 start
```


Backups and restoring
=====================

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

To restore a database, first identify the database you want to restore in the backup directory.

eg:

```bash
root@hubzero:~# ls /mnt/backup/mysqlbackup/daily/example/
example_2015-02-04_03h43m.Wednesday.sql.gz
```

The `.gz` extension shows that the backup is compressed.

To restore it you first need to uncompress it:

```bash
root@hubzero:~# gunzip /mnt/backup/mysqlbackup/daily/example/example_2015-02-04_03h43m.Wednesday.sql.gz
```

Once uncompressed, restore it as follows (note that this is done as the root user):

```bash
root@hubzero:~# mysql -h localhost -u root example < /mnt/backup/mysqlbackup/daily/example/example_2015-02-04_03h43m.Wednesday.sql
```

LDAP
----

The script ldapbackup.sh in..

To restore the ldap database:

```bash
# you first need to uncompress your chosen database
gunzip /mnt/backup/ldap/ldap-150204-0522.ldif.gz

# stop slapd from running
/etc/init.d/slapd stop

# delete the existing database
cd /var/lib/ldap
rm -rf *

# restore the database from your selected backup
/usr/sbin/slapadd -l /mnt/backup/ldap/ldap-150204-0522.ldif

# start the slapd again
/etc/init.d/slapd start
```

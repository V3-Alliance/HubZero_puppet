One of way of resizing: Snapshot, move to a volume, increase the size to a larger volume, then boot from the volume.
http://dev.cloudwatt.com/en/blog/How-to-migrate-OpenStack-resources.htm

However, it would appear that the NeCTAR infrastructure won't allow VM's to boot that are larger than 10G in primary 
disk size.

Hence this simple fix doesn't work for us :(

So we are left with moving directories off of the boot volume and onto the transient storage:

So move apache directory do something along the lines of:
$ mv /var/www /home/
$ ln -s /home/www /var/www

Then need to edit
/etc/apache2/sites-enabled/example
/etc/apache2/sites-enabled/example-ssl
To allow root to follow symlinks.

This is going to be quite a big job: it also means that our backups in swift become very important!

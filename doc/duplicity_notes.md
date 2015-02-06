Duplicity
=========

http://techs.enovance.com/5776/using-duplicity-with-cloudwatt-for-online-backups


To run duplicity, we need to install the python lock file:

```bash
# for keystone and swift
apt-get install python-pip

# for duplicity
apt-get install gnupg2
apt-get install python-lockfile

# for keystone and duplicity build
apt-get install python-dev

# for duplicity build
apt-get install librsync-dev

# install the python and keystone clients
pip install python-swiftclient
pip install python-keystoneclient

# install duplicity
cd /opt
wget https://launchpad.net/duplicity/0.7-series/0.7.01/+download/duplicity-0.7.01.tar.gz
tar xvzf duplicity-0.7.01.tar.gz
python setup.py install
```

Then we need to have the following in the environment:

```bash
#!/bin/bash

export SWIFT_USERNAME="tenancy_name:user_id"
export SWIFT_PASSWORD="user_password"
export SWIFT_AUTHURL="https://keystone.rc.nectar.org.au:5000/v2.0/"
export SWIFT_AUTHVERSION="2"
```

To list current files in swift: `/usr/local/bin/duplicity list-current-files swift://duplicity`
To backup  files to   swift: `/usr/local/bin/duplicity /mnt/backup/ swift://duplicity`
To restore files from swift: `/usr/local/bin/duplicity swift://duplicity /mnt/backup`

If you export a passphrase you don't need to generate a pgp key...

```bash
export PASSPHRASE=SOME_PASSPHRASE
```
For more, see: http://thomassileo.com/blog/2012/07/19/ubuntu-slash-debian-encrypted-incremental-backups-with-duplicity-on-amazon-s3/

To go the full pgp monty, see: https://raymii.org/s/tutorials/Encrypted_Duplicity_Backups_to_Openstack_Swift_Objectstore.html



#!/bin/bash
# We do not do the -e arg here as we want to backup as much is as possible.
# We also want to write to system error if there is a failure so that we are notified by the automysqlbackup script.

function progress_check {
    if [ $? -eq 0 ]
    then
        echo "Successfully backed up $1"
    else
        echo "Could not create $1 backup" >&2
    fi
}

nice /etc/ldapbackup
progress_check "ldap database"

nice /etc/sitebackup
progress_check "site files"

nice /etc/userbackup
progress_check "users"

nice /etc/secretsbackup
progress_check "secrets"

# secure the backups from prying eyes.
chmod -R 640 /mnt/backup/
progress_check "read only"

nice /etc/swiftbackup
progress_check "swift"

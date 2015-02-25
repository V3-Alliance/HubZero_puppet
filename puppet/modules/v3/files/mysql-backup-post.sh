#!/bin/bash -e

function progress_check {
    if [ $? -eq 0 ]
    then
        echo "Successfully backed up $1"
    else
        echo "Could not create $1 backup" >&2
    fi
}

/etc/ldapbackup
progress_check "ldap database"

/etc/sitebackup
progress_check "site files"

/etc/userbackup
progress_check "users"

source /etc/nectar.secrets
duplicity /mnt/backup/ swift://$(hostname)

progress_check "swift"
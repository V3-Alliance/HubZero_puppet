#!/bin/bash -e

function do_backup_directory {

    USER_BACKUP_FILE=$1-$( date +%y%m%d-%H%M ).tar.gz
    BACKUP_DIR=/mnt/backup/$1

    mkdir -p ${BACKUP_DIR}

    # delete any backup older than 7 days
    find ${BACKUP_DIR} -mtime +7 -delete

    # and tar up the backup directory
    tar -zcpPf ${BACKUP_DIR}/${USER_BACKUP_FILE} $2
}

do_backup_directory 'sites', '/var/www/'
do_backup_directory 'srv', '/srv/'

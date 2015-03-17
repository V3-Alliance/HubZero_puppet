#!/bin/bash -e

USER_BACKUP_FILE=sites-$( date +%y%m%d-%H%M ).tar.gz
BACKUP_DIR=/mnt/backup/sites

mkdir -p ${BACKUP_DIR}

# delete any backup older than 7 days
find ${BACKUP_DIR} -mtime 7 -delete

# and tar up the backup directory
tar -zcpPf ${BACKUP_DIR}/${USER_BACKUP_FILE} /var/www/

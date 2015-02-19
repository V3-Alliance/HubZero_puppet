#!/bin/sh -ex

USER_BACKUP_FILE=sites-$( date +%y%m%d-%H%M ).tar.gz
BACKUP_DIR=/mnt/backup/sites

mkdir -p $BACKUP_DIR
tar -zcpPf $BACKUP_DIR/$USER_BACKUP_FILE /var/www/

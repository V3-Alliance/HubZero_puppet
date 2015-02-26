#!/bin/bash -e

BACKUP_DIR=/mnt/backup/$(hostname)
mkdir -p $BACKUP_DIR
cp /etc/hubzero.secrets $BACKUP_DIR
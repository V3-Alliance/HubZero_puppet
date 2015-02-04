#!/bin/sh
LDAP_BACKUP_FILE=ldap-$( date +%y%m%d-%H%M ).ldif
BACKUP_DIR=/mnt/backup/ldap
mkdir -p $BACKUP_DIR
/usr/sbin/slapcat -v -l $BACKUP_DIR/$LDAP_BACKUP_FILE
gzip -9 $BACKUP_DIR/$LDAP_BACKUP_FILE

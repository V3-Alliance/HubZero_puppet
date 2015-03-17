#!/bin/bash -e

# based on: https://help.ubuntu.com/lts/serverguide/openldap-server.html#ldap-backup
# see http://arthurdejong.org/nss-pam-ldapd/setup on how to debug this lot...

BACKUP_DIR=/mnt/backup/ldap

mkdir -p ${BACKUP_DIR}

# delete any backup older than 7 days
find ${BACKUP_DIR} -mtime 7 -delete

WORKING_DIR=${BACKUP_DIR}/scratch
LDAP_BACKUP_FILE=${BACKUP_DIR}/ldap-$( date +%y%m%d-%H%M ).tar.gz
SLAPCAT=/usr/sbin/slapcat

mkdir -p ${WORKING_DIR}
${SLAPCAT} -n 0 > ${WORKING_DIR}/config.ldif
${SLAPCAT} -n 1 > ${WORKING_DIR}/$(hostname).ldif
cp /etc/nslcd.conf ${WORKING_DIR}

tar -zcpPf ${LDAP_BACKUP_FILE} ${WORKING_DIR}
rm -r ${WORKING_DIR}
#!/bin/bash -e

# based on: http://www.cyberciti.biz/faq/howto-move-migrate-user-accounts-old-to-new-server/

USER_BACKUP_FILE=users-$( date +%y%m%d-%H%M ).tar.gz
BACKUP_DIR=/mnt/backup/users

mkdir -p ${BACKUP_DIR}

# delete any backup older than 7 days
find ${BACKUP_DIR} -mtime +7 -delete

WORKING_DIR=${BACKUP_DIR}/scratch
UGIDLIMIT=1000
mkdir -p ${WORKING_DIR}
awk -v LIMIT=${UGIDLIMIT} -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd > ${WORKING_DIR}/passwd.mig
awk -v LIMIT=${UGIDLIMIT} -F: '($3>=LIMIT) && ($3!=65534)' /etc/group > ${WORKING_DIR}/group.mig
awk -v LIMIT=${UGIDLIMIT} -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - | egrep -f - /etc/shadow > ${WORKING_DIR}/shadow.mig || (( $?==1 ))
cp /etc/gshadow ${WORKING_DIR}/gshadow.mig
tar -zcpPf ${WORKING_DIR}/home.tar.gz /home
tar -zcpPf ${WORKING_DIR}/mail.tar.gz /var/spool/mail
tar -zcpPf ${BACKUP_DIR}/${USER_BACKUP_FILE} ${WORKING_DIR}
rm -r ${WORKING_DIR}
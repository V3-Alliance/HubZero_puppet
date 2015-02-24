#!/bin/bash -e

/etc/ldapbackup
/etc/sitebackup
/etc/userbackup
source /etc/nectar.secrets
duplicity /mnt/backup/ swift://$(hostname)
#!/bin/sh -e

/etc/ldapbackup
/etc/sitebackup
/etc/userbackup
duplicity /mnt/backup/ swift://$(hostname)
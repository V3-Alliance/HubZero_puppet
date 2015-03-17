#!/bin/bash -e

# values needed in a seperate file so we can source them from the command line as well
source /etc/nectar.secrets

# perform a full backup every seven days
duplicity --volsize 100 --full-if-older-than 7D /mnt/backup/ swift://$(hostname)

# delete all backups older than a month
duplicity remove-older-than 1M --force swift://$(hostname)

unset SWIFT_PASSWORD
unset PASSPHRASE
#!/bin/bash -e

# values needed in a seperate file so we can source them from the command line as well
source /etc/nectar.secrets

# keystone client writes warnings to syserr: which automysql backup then assumes to mean an error occured.
# hence we trap the error stream to a variable, then, if duplicity failes, echo it back into the syserr stream.
# Otherwise we just move on.
function do_with_captured_syserr {
    ERROR="$($1 2>&1 > /dev/null)"
    if [ $? -ne 0 ]
    then
        >&2 echo ${ERROR};
    fi
}

# perform a full backup every seven days
do_with_captured_syserr "duplicity --volsize 100 --full-if-older-than 7D /mnt/backup/ swift://$(hostname)-bucket"

# delete all backups older than a month
do_with_captured_syserr "duplicity remove-older-than 1M --force swift://$(hostname)-bucket"

unset SWIFT_PASSWORD
unset PASSPHRASE
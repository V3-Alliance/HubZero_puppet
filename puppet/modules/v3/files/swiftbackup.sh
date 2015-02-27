#!/bin/bash -e

source /etc/nectar.secrets
duplicity --volsize 100 /mnt/backup/ swift://$(hostname)

duplicity remove-older-than 7D00s --force swift://$(hostname)

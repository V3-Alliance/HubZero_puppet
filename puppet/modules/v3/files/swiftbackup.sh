#!/bin/bash -e

source /etc/nectar.secrets
duplicity --volsize 100 /mnt/backup/ swift://$(hostname)

duplicity remove-older-than 7d --force swift://$(hostname)

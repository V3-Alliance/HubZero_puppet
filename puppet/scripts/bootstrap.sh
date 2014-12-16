#!/bin/sh

# This is a bash script that will kick start the installation of hub zero on the target machine.
# It makes the assumption that it is being run as the root user.

# Registered temporary domain at http://www.dot.tk/en/index.html?lang=en ...

# first up, add the hub zero package repository
echo "deb http://packages.hubzero.org/deb manny main" | tee -a /etc/apt/sources.list

# Don’t get the 1.1 key: it’s expired. Rather use the 1.2 (seems to work)

apt-key adv --keyserver pgp.mit.edu --recv-keys 143C99EF



apt-get -y install puppet git
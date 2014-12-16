#!/bin/sh

# This is a bash script that will kick start the installation of hub zero on the target machine.
# It makes the assumption that it is being run as the root user. So run it as the user_data segment of the
# vm launch.


# Set hostname
# registered temporary domain at http://www.dot.tk/en/index.html?lang=en ...
hostname hubzero.tk
# and make the name change permanent
echo "hubzero.tk" > /etc/hostname

# Fix hosts
# remove the line: 127.0.1.1	localhost.locahost	localhost
sed -i".bak" '/127.0.1.1/d' /etc/hosts
# and replace it with the intended one
echo "127.0.1.1 	hubzero.tk" | tee -a /etc/hosts

# Delete local users
# since we still want to log in as the debian user we'll just move their ID to an acceptible range
usermod -u 999 debian

# Configure networking
# the default VM settings should work

# Setting up DNS
# the default VM settings should work


# Configure Advanced Package Tool
echo "deb http://packages.hubzero.org/deb manny main" | tee -a /etc/apt/sources.list
# the 1.1 key has expired but the 1.2 key seems to work
apt-key adv --keyserver pgp.mit.edu --recv-keys 143C99EF

apt-get update
apt-get upgrade

# now we get ready to hand over to puppet
apt-get -y install puppet git
git clone https://github.com/MartinPaulo/puppet_hub_zero.git
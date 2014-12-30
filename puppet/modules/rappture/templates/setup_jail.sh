#!/bin/sh

cd <%= $chroot_dir %>
chroot <%= $chroot_dir %>
apt-get update
apt-get -y upgrade
apt-get -y install hubzero-rappture-session
apt-get -y autoremove
exit
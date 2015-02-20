class hubzero_1_3 {
  include mysql_hubzero
  include exim4
  include cms
  include open-ldap
  include webdav
  include subversion
  include trac
  include forge
  include openvz
  include firewall
  include maxwell-service
  include maxwell-client
  include vncproxy
  include telequotad
  include workspace
  include metrics
  include rappture
  include filexfer
# include submit
# now the v3 support packages
# first off, the nagios checks
  include nrpe
  include nrpe::absolutememory
  include nrpe::apachememory
# we want the machine to install security updates automatically.
  include unattended_upgrades
# we want to have V3 admins able to access the machine
  include v3::admins
# we want to have NTP
  include '::ntp'
# we want to backup up the database
  include v3::backups
# and write the backup to swift
  include v3::duplicity
  include v3::swift
}
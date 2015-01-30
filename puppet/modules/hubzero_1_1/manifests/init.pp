class hubzero_1_1 {
  include mysql_1_1
  include exim4
  include cms
  include open-ldap
# skip ssh and sftp as they are buggy...
  include webdav
  include subversion
  include trac
  include forge
  include openvz
  include firewall
  include maxwell-service # Is broken...
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
}

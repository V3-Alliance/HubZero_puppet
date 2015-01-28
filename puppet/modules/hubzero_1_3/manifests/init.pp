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
}
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
  include v3::support
}

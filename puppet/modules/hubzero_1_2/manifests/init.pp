class hubzero_1_2 {
  include mysql_hubzero
#  # include exim4
  include cms
  include open-ldap
  include webdav
  include subversion
  include trac
  include forge
  include openvz
  include firewall
  include maxwell-service # Is broken...
  include maxwell-client
  include vncproxy
#  # include telequotad
  include workspace
#  include metrics # metrics for 1.2.2 is broken, the advice is not to install it...
#  # include rappture
#  include filexfer
#  # include submit
}
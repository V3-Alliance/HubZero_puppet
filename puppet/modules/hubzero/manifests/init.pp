class hubzero {
  include hubzero-database
  # include exim4
  include cms
  include open-ldap
  # skip ssh and sftp
  include webdav
  # include subversion
  # include trac
  # include forge
  # include openvz
  # include firewall
  # include maxwell-service
  # include maxwell-client
  # include vncproxy
  # include telequotad
  # include workspace
  # include metrics
  # include rappture
  # include filexfer
  # include submit
}
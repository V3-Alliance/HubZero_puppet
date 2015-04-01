# This is based on:
# https://www.howtoforge.com/creating-mysql-backups-with-automysqlbackup
#
# TODO: We need to work out who to send the emails to...
class v3::backups {

  package { "automysqlbackup":
    ensure => latest,
  }

  file { "/etc/default/automysqlbackup":
    ensure    => file,
    source    => "puppet:///modules/v3/automysqlbackup.sh",
    require   => Package ['automysqlbackup'],
    mode      => '0644',
  } ->
  file { "/etc/ldapbackup":
    ensure    => file,
    source    => "puppet:///modules/v3/ldapbackup.sh",
    mode      => '0744',
  } ->
  file { "/etc/sitebackup":
    ensure    => file,
    source    => "puppet:///modules/v3/sitebackup.sh",
    mode      => '0744',
  } ->
  file { "/etc/userbackup":
    ensure    => file,
    source    => "puppet:///modules/v3/userbackup.sh",
    mode      => '0744',
  } ->
  file { "/etc/secretsbackup":
    ensure    => file,
    source    => "puppet:///modules/v3/secretsbackup.sh",
    mode      => '0744',
  } ->
  file { "/etc/swiftbackup":
    ensure    => file,
    source    => "puppet:///modules/v3/swiftbackup.sh",
    mode      => '0744',
  } ->
  file { "/etc/mysql-backup-post":
    ensure    => file,
    source    => "puppet:///modules/v3/mysql-backup-post.sh",
    mode      => '0744',
  } ->
  exec { "backup events table":
    # we are not backing the events table, and hence getting a mysql error reported. This is a dirty fix.
    # http://blog.crythias.com/2013/05/solve-automysqlbackup-warning-mysqlevent.html
    command => '/bin/sed -i.bak "s|\"--quote-names\"|\"--quote-names --events\"|" /usr/sbin/automysqlbackup',
  }

}
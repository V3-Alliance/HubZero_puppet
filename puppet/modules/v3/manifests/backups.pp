# This is based on:
# https://www.howtoforge.com/creating-mysql-backups-with-automysqlbackup.sh-on-ubuntu-9.10
#
# TODO: We need to work out who to send the emails to...
class v3::backups {

  package { "automysqlbackup":
    ensure => latest,
  }

  file {"/etc/default/automysqlbackup":
    ensure    => file,
    source    => "puppet:///modules/v3/automysqlbackup",
    require   => Package ['automysqlbackup-nrpe-server'],
    mode      => '0644',
  }

}
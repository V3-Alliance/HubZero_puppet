#/etc/puppet/modules/nrpe/manifests/init.pp
# On the nagios server:
#   The matching file for this setup is:
#       /etc/nagios/conf.d/hubzero-martin.cfg
#   To debug what's going on:
#       http://support.nagios.com/forum/viewtopic.php?f=7&t=5807&start=0
#   The command to check any changes to it is:
#       service nagios checkconfig
#   The command to restart nagios after any config changes is:
#       systemctl restart nagios
#
# to check these rules from the nagios server do something along the lines of, where the ip number is the
# ip number of the target machine:
#  /usr/lib64/nagios/plugins/check_nrpe -H 115.146.87.78 -c check_load
#  /usr/lib64/nagios/plugins/check_nrpe -H 115.146.87.78 -c apachememory
#  /usr/lib64/nagios/plugins/check_nrpe -H 115.146.87.78 -c absolutememory
#  /usr/lib64/nagios/plugins/check_nrpe -H 115.146.87.78 -c check_all_disks
#  /usr/lib64/nagios/plugins/check_nrpe -H 115.146.87.78 -c check_ntp_time


class nrpe (
  $nagiosservers = $nrpe::nagiosservers,
  $nagios_mysql_password = $nrpe::nagios_mysql_password,
) {

# if we want this to log to its own file:
#    http://www.charlesjudith.com/2014/03/11/create-a-log-file-for-nrpe/
# if we want to debug what's going on:
#    http://www.lowlevelmanager.com/2012/05/debugging-nagios-remote-nrpe-commands.html
  package { 'nagios-nrpe-server':
    ensure  => installed,
  }

#required for server memory and absolutememory nagios checks.
  package { 'python-psutil':
    ensure  => installed,
  }

  file { '/etc/nagios/nrpe.cfg':
    ensure     => file,
    content    => template('nrpe/nrpe.cfg.erb'),
    require    => Package ['nagios-nrpe-server'],
    notify     => Service ['nagios-nrpe-server'],
  }

  service { 'nagios-nrpe-server':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['nagios-nrpe-server'],
  }

#The nagios user needs to read hosts.deny, which
#it does not have permission to do by default.
#If it does not have this permission, it says
#that the access is denied by tcpwrapper, even
#if not specified.
  file { '/etc/hosts.deny':
    mode   => '0644',
  }

  file { '/etc/nagios/nrpe.d/check_ntp_time.cfg':
    ensure    => file,
    content   => template('nrpe/check_ntp_time.cfg.erb'),
    require   => Package ['nagios-nrpe-server'],
    notify    => Service ['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/check_all_disks.cfg':
    ensure    => file,
    content   => template('nrpe/check_all_disks.cfg.erb'),
    require   => Package ['nagios-nrpe-server'],
    notify    => Service ['nagios-nrpe-server'],
  }

  exec { 'create nagios mysql user':
    command => "mysql -h localhost -u root -e \"GRANT SELECT ON example.* TO 'nagios'@'localhost' IDENTIFIED BY '${nagios_mysql_password}';\"",
    path    => "/usr/local/bin:/usr/bin/:/root",
    # following breaks 1.1 :(
    require => Package ['hubzero-mysql'],
  }
  ->
  file { '/etc/nagios/nrpe.d/check_mysql.cfg':
    ensure    => file,
    content   => template('nrpe/check_mysql.cfg.erb'),
    require   => Package ['nagios-nrpe-server'],
    notify    => Service ['nagios-nrpe-server'],
  }


}

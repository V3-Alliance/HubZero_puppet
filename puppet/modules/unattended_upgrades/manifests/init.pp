# https://wiki.debian.org/UnattendedUpgrades
class unattended_upgrades {

  package { "apt-listchanges":
    ensure => installed,
  }

  package { "unattended-upgrades":
    ensure  => installed,
    require => Package["apt-listchanges"],
  }

  file { "/etc/apt/apt.conf.d/50unattended-upgrades":
    ensure => file,
    source => "puppet:///modules/unattended_upgrades/50unattended-upgrades",
  }

  cron { "unattended-upgrades":
    require     => [
      File ['/etc/apt/apt.conf.d/50unattended-upgrades'],
      Package ['unattended-upgrades'],
    ],
    command     => '/usr/bin/unattended-upgrade',
    user        => root,
    hour        => '*/6',
    minute      => '30',
    environment => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  }
}

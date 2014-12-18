class cms {

  package { "hubzero-cms":
    ensure => latest,
  }

  exec { "install example site":
    command => "/usr/bin/hzcms install example",
    require => [Package["hubzero-cms"]],
  }

  exec { "disable default sites":
    command   => "/usr/sbin/a2dissite default default-ssl",
    subscribe => Exec["install example site" ],
  }

  exec { "enable sample sites":
    command   => "/usr/sbin/a2ensite example example-ssl",
    subscribe =>  Exec["disable default sites"],
  }

  exec { "restart apache":
    command   => "/etc/init.d/apache2 restart",
    subscribe => Exec["enable sample sites"]
  }
}
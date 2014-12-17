class cms {

  package { "hubzero-cms":
    ensure => latest,
  }

  exec { "install example":
    command => "hzcms install example",
    require => [Package["hubzero-cms"]],
  }

  exec { "disable default sites":
    command   => "a2dissite default default-ssl",
    subscribe => Exec["install example" ],
  }

  exec { "enable sample sites":
    command   => "a2ensite example example-ssl",
    subscribe =>  Exec["disable default sites"],
  }

  exec { "restart apache":
    command   => "/etc/init.d/apache2 restart",
    subscribe => Exec["enable sample sites"]
  }
}
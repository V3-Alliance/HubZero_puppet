class vncproxy {

  package { "hubzero-vncproxy":
    ensure => latest,
  }

  exec { "initialize vncproxy":
    command      => "/usr/bin/hzcms configure vncproxy --enable",
    require      => [Package["hubzero-vncproxy"], Package["hubzero-cms"]],
  }
}
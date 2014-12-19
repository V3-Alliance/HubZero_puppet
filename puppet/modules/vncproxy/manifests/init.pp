class vncproxy {

  package { "hubzero-vncproxy":
    ensure => latest,
  }

  exec { "initialize trac":
    command      => "/usr/bin/hzcms configure vncproxy --enable",
    require      => [Package["hubzero-vncproxy"], Package["hubzero-cms"]],
  }
}
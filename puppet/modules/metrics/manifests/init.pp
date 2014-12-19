class metrics {

  package { "hubzero-metrics":
    ensure => latest,
  }

  exec { "initialize metrics":
    command      => "/usr/bin/hzcms configure metrics --enable",
    require      => [Package["hubzero-metrics"], Package["hubzero-cms"]],
  }
}
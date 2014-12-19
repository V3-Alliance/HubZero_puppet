class forge {

  package { "hubzero-forge":
    ensure => latest,
  }

  exec { "initialize forge":
    command      => "/usr/bin/hzcms configure forge --enable",
    require      => Package ["hubzero-forge, hubzero-cms"],
  }
}
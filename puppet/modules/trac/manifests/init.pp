class trac {

  package { "hubzero-trac":
    ensure => latest,
  }

  exec { "initialize trac":
    command      => "/usr/bin/hzcms configure trac --enable",
    require      => Package ["hubzero-trac"],
  }
}
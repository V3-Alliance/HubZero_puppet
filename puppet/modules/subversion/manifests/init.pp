class subversion {

  package { "hubzero-subversion":
    ensure => latest,
  }

  exec { "initialize subversion":
    command      => "/usr/bin/hzcms configure subversion --enable",
    require      => Package ["hubzero-subversion"],
  }
}
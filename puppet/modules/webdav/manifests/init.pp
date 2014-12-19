class webdav {

  package { "hubzero-webdav":
    ensure => latest,
  }

  exec { "initialize webdav":
    command      => "/usr/bin/hzcms configure webdav --enable",
    require      => [Package["hubzero-webdav"], Package["hubzero-cms"]],
  }
}
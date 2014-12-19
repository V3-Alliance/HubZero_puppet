class filexfer {

  package { "hubzero-filexfer-xlate":
    ensure => latest,
  }

  exec { "initialize filexer":
    command      => "/usr/bin/hzcms configure filexfer --enable",
    require      => [Package["hubzero-filexfer-xlate"], Package["hubzero-cms"]],
  }
}
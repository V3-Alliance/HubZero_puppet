class workspace {

  package { "hubzero-app":
    ensure => latest,
  }

  package { "hubzero-app-workspace":
    ensure => latest,
    require      => Package["hubzero-app"],
  }

  exec { "initialize workspace":
    command      => "/usr/bin/hubzero-app install --publish /usr/share/hubzero/apps/workspace-1.3.hza",
    require      => Package["hubzero-app-workspace"]
  }
}
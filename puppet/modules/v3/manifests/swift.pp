class v3::swift {

  package { "python-pip":
    ensure => "installed"
  }
  ->
  exec { "keystone":
  # bizarro: this seems to install a new version of pip in a different location...
    command => "pip install python-keystoneclient",
    require => Package["python-dev"],
    path    => "/usr/local/bin:/usr/bin"
  }
  ->
  exec { "swift":
    command => "pip install python-swiftclient",
    path    => "/usr/local/bin:/usr/bin/"
  }
  ->
  exec { "distribute":
    command => "pip install --upgrade distribute",
    path    => "/usr/local/bin:/usr/bin/"
  }
}

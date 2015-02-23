class v3::swift (
){

  package { "python-pip":
    ensure => "installed"
  }
  ->
  exec { "keystone":
  # bizarro: this seems to install a new version of pip in a different location...
    command => "pip install python-keystoneclient",
    require => Package["python-dev"],
    path    => "/bin"
  }
  ->
  exec { "swift":
    command => "pip install python-swiftclient",
    path    => "/bin"
  }
  ->
  exec { "distribute":
    command => "pip install --upgrade distribute",
    path    => "/bin"
  }
}

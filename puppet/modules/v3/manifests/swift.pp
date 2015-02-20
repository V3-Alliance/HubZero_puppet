class v3::swift (
){

  $swift_requires = [ "python-pip", "python-dev" ]

  package { $swift_requires:
    ensure => "installed"
  }
  ->
  exec { "keystone":
    command => "/usr/bin/pip install python-keystoneclient",
  }

  exec { "swift":
    command => "/usr/bin/pip install python-swiftclient",
  }

}

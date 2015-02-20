class v3::swift (
){

package { "python-pip":
  ensure => "installed"
}
->
exec { "keystone":
  command => "/usr/local/bin/pip install python-keystoneclient",
  require => Package["python-dev"],
}
->
exec { "swift":
  command => "/usr/local/bin/pip install python-swiftclient",
}

}

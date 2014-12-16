class hubzero-database {

 user {'katie':
    ensure => absent,
  }

 # class { 'mysql::server':
 #   root_password => 'password',
 # }

}

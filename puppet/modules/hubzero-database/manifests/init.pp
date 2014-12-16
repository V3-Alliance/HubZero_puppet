class hubzero-database {

  class { 'mysql::server':
    root_password => 'password',
  }

}

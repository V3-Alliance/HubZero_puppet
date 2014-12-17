class hubzero-database (
  $mysql_password,
){

  class { 'mysql::server':
    root_password => "$mysql_password",
  }

}

class hubzero-database (
  $mysql_password,
){

# TODO: This gives the following root users: we should possibly clear the two without passwords?
# mysql> select Host,Password from user where User='root';
# +------------+-------------------------------------------+
# | Host       | Password                                  |
# +------------+-------------------------------------------+
# | localhost  | *935709B6DFFF2CEA9CDC9B3448E49178478D1774 |
# | hubzero.tk |                                           |
# | 127.0.0.1  |                                           |
# +------------+-------------------------------------------+


class { 'mysql::server':
    root_password => "$mysql_password",
  }

}

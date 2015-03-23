# <h2>MySql</h2>
# <p>Installed using the Puppet MySql module
# <p>Used by 1.1
# <p>See: <a href="https://hubzero.org/documentation/1.1.0/installation/Setup.mysql">1.1 Install Instructions</a>
class mysql_1_1 (
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
    root_password           => "$mysql_password",
    remove_default_accounts => true,
    before                  => Exec['create nagios mysql user'],
  }

}

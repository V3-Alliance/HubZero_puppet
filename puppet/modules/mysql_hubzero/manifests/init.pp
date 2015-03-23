# <h2>MySql</h2>
# <p>Installed from the hub zero repository
# <p>Used by both 1.2 and 1.3
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.mysql">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.mysql">1.3 Install Instructions</a>
# </ul>
class mysql_hubzero {

  package { "hubzero-mysql":
    ensure => latest,
    before => Package['nagios-nrpe-server'],
  }

}
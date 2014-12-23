# <h2>Trac</h2>
# <p>Install and configure Trac.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.trac">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.trac">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.trac">1.3 Install Instructions</a>
# </ul>
class trac {

  package { "hubzero-trac":
    ensure => latest,
  }

  exec { "initialize trac":
    command      => "/usr/bin/hzcms configure trac --enable",
    require      => [Package["hubzero-trac"], Package["hubzero-cms"]],
  }
}
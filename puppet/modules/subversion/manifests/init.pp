# <h2>Subversion</h2>
# <p>Install and configure Subversion.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.subversion">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.subversion">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.subversion">1.3 Install Instructions</a>
# </ul>
class subversion {

  package { "hubzero-subversion":
    ensure => latest,
  }

  exec { "initialize subversion":
    command      => "/usr/bin/hzcms configure subversion --enable",
    require      => [Package["hubzero-subversion"], Package["hubzero-cms"]],
  }
}
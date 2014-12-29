# <h2>Forge</h2>
# <p>Install and configure Forge.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.forge">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.forge">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.forge">1.3 Install Instructions</a>
# </ul>
class forge {

  package { "hubzero-forge":
    ensure => latest,
  }

  exec { "initialize forge":
    command      => "/usr/bin/hzcms configure forge --enable",
    require      => [Package["hubzero-forge"], Package["hubzero-cms"], Exec["initialize subversion"],
      Exec["initialize trac"],  Exec["enable ldap"]],
  }
}
# <h2>Maxwell client</h2>
# <p>Installs the HubZero Maxwell client.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.maxwell_client">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.maxwell_client">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.firewall">1.3 Install Instructions</a>
# </ul>
class maxwell-client {

  package { "hubzero-mw-client":
    ensure       => latest,
    require      => Exec["enable maxwell"],
  }

  exec { "initialize maxwell client":
    command      => "/usr/bin/hzcms configure mw-client --enable",
    require      => [Package["hubzero-mw-client"], Package["hubzero-cms"]],
  }
}
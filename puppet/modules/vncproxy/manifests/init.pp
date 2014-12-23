# <h2>VNCProxy</h2>
# <p>Installs the VNCProxy.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.vncproxy">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.vncproxy">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.vncproxy">1.3 Install Instructions</a>
# </ul>
class vncproxy {

  package { "hubzero-vncproxy":
    ensure => latest,
  }

  exec { "initialize vncproxy":
    command      => "/usr/bin/hzcms configure vncproxy --enable",
    require      => [Package["hubzero-vncproxy"], Package["hubzero-cms"]],
  }
}
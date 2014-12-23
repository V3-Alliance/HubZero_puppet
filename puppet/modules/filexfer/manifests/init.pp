# <h2>Filexfer</h2>
# <p>Installs the Filexfer module.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.filexfer">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.filexfer">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.filexfer">1.3 Install Instructions</a>
# </ul>
class filexfer {

  package { "hubzero-filexfer-xlate":
    ensure => latest,
  }

  exec { "initialize filexer":
    command      => "/usr/bin/hzcms configure filexfer --enable",
    require      => [Package["hubzero-filexfer-xlate"], Package["hubzero-cms"]],
  }
}
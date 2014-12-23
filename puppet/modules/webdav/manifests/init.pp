# <h2>WebDAV</h2>
# <p>Install and configure WebDAV.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.webdav">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.webdav">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.webdav">1.3 Install Instructions</a>
# </ul>
class webdav {

  package { "hubzero-webdav":
    ensure => latest,
  }

  exec { "initialize webdav":
    command      => "/usr/bin/hzcms configure webdav --enable",
    require      => [Package["hubzero-webdav"], Package["hubzero-cms"]],
  }
}
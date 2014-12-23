# <h2>Metrics</h2>
# <p>Installs the Metrics module.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.metrics">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.metrics">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.metrics">1.3 Install Instructions</a>
# </ul>
class metrics {

  package { "hubzero-metrics":
    ensure => latest,
  }

  exec { "initialize metrics":
    command      => "/usr/bin/hzcms configure metrics --enable",
    require      => [Package["hubzero-metrics"], Package["hubzero-cms"]],
  }
}
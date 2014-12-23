# <h2>Firewall</h2>
# <p>Installs the HubZero firewall.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.firewall">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.firewall">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.firewall">1.3 Install Instructions</a>
# </ul>
class firewall {

  package { "hubzero-firewall":
    ensure => latest,
  }

}
# <h2>Exim4</h2>
# <p>Used by all versions of HubZero
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.exim4">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.mysql">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.mysql">1.3 Install Instructions</a>
# </ul>
class exim4 (
  $fqdn
){
  # based on
  #  http://projects.puppetlabs.com/projects/1/wiki/debian_preseed_patterns
  #  http://blogs.cae.tntech.edu/mwr/2008/02/05/stupid-puppet-trick-agreeing-to-the-sun-java-license-with-debconf-preseeds-and-puppet/

  package { "exim4":
    require => File ["/var/cache/debconf/exim4.seeds"],
    responsefile => "/var/cache/debconf/exim4.seeds",
    ensure => latest;
  }

  file {"/var/cache/debconf/exim4.seeds":
    content => template ('exim4/exim4.seeds.erb'),
    ensure => present;
  }

}


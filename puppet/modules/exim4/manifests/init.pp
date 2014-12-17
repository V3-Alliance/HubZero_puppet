class exim4 {
  # based on http://blogs.cae.tntech.edu/mwr/2008/02/05/stupid-puppet-trick-agreeing-to-the-sun-java-license-with-debconf-preseeds-and-puppet/
  # TODO: but now need to set up the correct response file.

  package { "exim4":
    require => File ["/var/cache/debconf/exim4.seeds"],
    responsefile => "/var/cache/debconf/exim4.seeds",
    ensure => latest;
  }

  file {"/var/cache/debconf/exim4.seeds":
    source => "puppet:///modules/exim4/exim4.seeds",
    ensure => present;
  }

}


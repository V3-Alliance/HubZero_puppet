class open-ldap (
  $slapd_password,
){

# if not good enough, try https://github.com/jfernandezr/puppet-ldap/blob/master/manifests/server.pp

# after install can test with:
# sudo slapcat
  package { "slapd":
    ensure       => latest,
    require      => File ["/var/cache/debconf/slapd.seeds"],
    responsefile => "/var/cache/debconf/slapd.seeds",
  }

  file { "/var/cache/debconf/slapd.seeds":
    content => template("open-ldap/slapd.seeds"),
    ensure  => present,
  }

  package { "hubzero-openldap":
    ensure  => latest,
    require => [Package["slapd"]],
  }

#/usr/bin/hzldap

}
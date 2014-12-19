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

  exec { "initialize ldap":
    command      => "/usr/bin/hzldap init 2>&1 | tee /tmp/ldap_details.txt",
    require      => Package ["hubzero-openldap"],
    creates      => "/tmp/ldap_details.txt"
  }

  exec { "enable ldap":
    command      => "/usr/bin/hzcms configure ldap --enable",
    subscribe    => Exec["initialize ldap"]
  }

# somehow, need to:
#  Go to administrator section of your site (/administrator),
#  go to Site->Maintenance->LDAP and press the Export Users and Export Groups buttons
#  in order to export all CMS users/groups

# to test: # getent passwd
}
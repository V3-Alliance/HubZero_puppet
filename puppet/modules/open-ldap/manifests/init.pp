class open-ldap (
  $slapd_password,
){


# Install the preseed packages
  package { "slapd":
    ensure => latest,
    require => File ["/var/cache/debconf/slapd.seeds"],
    responsefile => "/var/cache/debconf/slapd.seeds",
  }

  file {"/var/cache/debconf/slapd.seeds":
    content => template("ldap/slapd.seeds"),
    ensure => present,
  }

  package { "hubzero-openldap":
    ensure => latest,
    require => [Package["slapd"]],
  }

}
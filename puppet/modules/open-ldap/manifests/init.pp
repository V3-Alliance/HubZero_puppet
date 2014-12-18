class open-ldap (
  $slapd_password,
){

  package { "slapd":
    ensure => latest,
  }

  package { "hubzero-openldap":
    ensure => latest,
    require => [Package["slapd"]],
  }

}
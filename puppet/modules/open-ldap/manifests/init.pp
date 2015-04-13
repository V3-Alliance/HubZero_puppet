# <h2>OpenLDAP</h2>
# <p>Install and configure LDAP.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.openldap">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.openldap">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.openldap">1.3 Install Instructions</a>
# </ul>
# <h3>Version 1.1 gotcha's</h3
# <p>TODO: Check: currently get the following message when installing :
# <pre>/Exec[enable ldap]/returns:
#     syncing user 'admin' to ldap#033[0m
#     pw = pwd.getpwnam('admin')#033[0m
#     KeyError: 'getpwnam(): name not found: admin'#033[0m
#</pre>
# <p>I'm not sure if this is meant to happen or not?

class open-ldap (
  $slapd_password,
  $version
){

# as the hub zero 1 & 2 packages install this, I'm not sure what harm is done by not making it a 1.1 option...
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
    ensure       => latest,
    responsefile => "/var/cache/debconf/ldap.seeds",
    require      => [Package["slapd"]],
  }

  file { "/var/cache/debconf/ldap.seeds":
    content => template("open-ldap/ldap.seeds"),
    ensure  => present,
  }

  exec { "initialize ldap":
    command => "/usr/bin/hzldap init 2>&1 | tee /etc/ldap.secrets",
    require => Package ["hubzero-openldap"],
    creates => "/etc/ldap.secrets"
  }
  ->
  exec { "set ldap file permissions":
    command => "chmod 600 /etc/nectar.secrets",
  }

  exec { "enable ldap":
    command   => "/usr/bin/hzcms configure ldap --enable",
    subscribe => Exec["initialize ldap"],
    require   => [Package ["hubzero-cms"], Package["hubzero-openldap"]],
  }

  if ($version!="1.1") {
    exec { "sync ldap users":
      command   => "/usr/bin/hzldap syncusers",
      subscribe => Exec["enable ldap"],
      require   => [Package ["hubzero-cms"], Package["hubzero-openldap"]],
    }
  }

}
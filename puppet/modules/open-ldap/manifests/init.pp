# <h2>OpenLDAP</h2>
# <p>Install and configure LDAP.
# <p><b>See:</b> <a href="https://hubzero.org/documentation/1.1.0/installation/Setup.openldap">https://hubzero.org/documentation/1.1.0/installation/Setup.openldap</a>
# <p>Currently get the following message:
# <pre>/Exec[enable ldap]/returns:
#     syncing user 'admin' to ldap#033[0m
#     pw = pwd.getpwnam('admin')#033[0m
#     KeyError: 'getpwnam(): name not found: admin'#033[0m
#</pre>
# <p>I'm not sure if this is meant to happen or not?
# <p>If this class is not good enough, try https://github.com/jfernandezr/puppet-ldap/blob/master/manifests/server.pp
# <p>TODO: somehow, need to:
#  <ul>
#<li>Go to administrator section of your site (/administrator),</li>
#<li>go to Site->Maintenance->LDAP and press the Export Users and Export Groups buttons
#  in order to export all CMS users/groups</li>
#</ul>

# to test: # getent passwd
class open-ldap (
  $slapd_password,
){

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
    command      => "/usr/bin/hzldap init 2>&1 | tee /root/ldap_details.txt",
    require      => Package ["hubzero-openldap"],
    creates      => "/root/ldap_details.txt"
  }

  exec { "enable ldap":
    command      => "/usr/bin/hzcms configure ldap --enable",
    subscribe    => Exec["initialize ldap"],
    require      => [Package ["hubzero-cms"], Package["hubzero-openldap"]],
  }

}
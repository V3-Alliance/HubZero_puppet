# <h2>Hubzero CMS</h2>
# <p>Installs the appropriate version of HubZero
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.cms">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.cms">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.cms">1.3 Install Instructions</a>
# </ul>
class cms (
  $version
){

  case $version {
    1.1: { $cms_version =  "hubzero-cms" }
    1.2: { $cms_version =  "hubzero-cms-1.2.0" }
    default : { $cms_version =  "hubzero-cms-1.3.0" }
  }

  package { "hubzero-cms":
    name   => $cms_version,
    ensure => latest,
  }

  exec { "install example site":
    command => "/usr/bin/hzcms install example",
    require => [Package["hubzero-cms"]],
  }

  exec { "disable default sites":
    command   => "/usr/sbin/a2dissite default default-ssl",
    subscribe => Exec["install example site" ],
  }

  exec { "enable sample sites":
    command   => "/usr/sbin/a2ensite example example-ssl",
    subscribe =>  Exec["disable default sites"],
  }

  exec { "restart apache":
    command   => "/etc/init.d/apache2 restart",
    subscribe => Exec["enable sample sites"]
  }
}
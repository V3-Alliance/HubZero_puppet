# <h2>Rappture</h2>
# <p>Install and configure <a href="https://nanohub.org/infrastructure/rappture/">rappture</a>.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.rappture">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.rappture">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.rappture">1.3 Install Instructions</a>
# </ul>
class rappture (
  $version
){

  case $version {
    1.1: { $chroot_dir =  "/var/lib/vz/template/debian-6.0-amd64-maxwell" }
    1.2: { $chroot_dir =  "/var/lib/vz/template/debian-7.0-amd64-maxwell" }
    default : { $chroot_dir =  "/var/lib/vz/template/debian-7.0-amd64-maxwell" }
  }

  package { "hubzero-rappture":
    ensure => latest,
  }

  file { "deploy rapture configure script":
    path    => "/usr/local/bin/setup_jail.sh",
    content => template ('rappture/setup_jail.erb'),
    mode    => '0755',
    ensure  => present,
    require => Package["hubzero-rappture"],
  }

  exec { "configure rappture":
    command      => "/usr/local/bin/setup_jail.sh",
    require      => [
      Package["hubzero-rappture"],
      Package["hubzero-mw-client"],
      File["deploy rapture configure script"]],
  }

}
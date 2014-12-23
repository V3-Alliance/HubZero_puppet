# <h2>OpenVZ</h2>
# <p>Installs the OpenVZ containers.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.openvz">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.openvz">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.openvz">1.3 Install Instructions</a>
# </ul>
# <p><b>Note:</b> Needs a reboot after this has been installed. This is
# currently handled by placing a <code>&& reboot</code> after the
# <code>puppet apply</code> command...
class openvz(
  $version
) {

  if $version == "1.1" {
    package { "linux-image-2.6-openvz-amd64":
      ensure => latest,
    }
  } else {
    package { "hubzero-openvz":
      ensure => latest,
    }

    exec { "initialize openvz":
      command      => "/usr/bin/hzcms configure openvz --enable",
      require      => [Package["hubzero-openvz"], Package["hubzero-cms"]],
    }
  }

# If we ever need to run the puppet scripts on startup we will have to
# change the reboot to be along these lines:
#  exec { "do reboot":
#    command      => "/sbin/reboot",
#    subscribe    => Stage['pre','main','aux'],
#    refreshonly  => true,
#    require      => Package["linux-image-2.6-openvz-amd64"],
#  }

}
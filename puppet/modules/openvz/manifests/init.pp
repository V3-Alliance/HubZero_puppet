# <h2>OpenVZ</h2>
# <p>Installs the OpenVZ containers.
# <p><b>Note:</b> Needs a reboot after this has been installed. This is
# currently handled by placing a <code>&& reboot</code> after the
# <code>puppet apply</code> command...
# <p>See: <a href= "https://hubzero.org/documentation/1.1.0/installation/Setup.openvz">https://hubzero.org/documentation/1.1.0/installation/Setup.openvz</a>
class openvz {
  package { "linux-image-2.6-openvz-amd64":
    ensure => latest,
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
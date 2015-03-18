# The v3 support packages
class v3::support {
# first off, the nagios checks
  include nrpe
  include nrpe::absolutememory
  include nrpe::apachememory
# we want the machine to install security updates automatically.
  include unattended_upgrades
# we want to have V3 admins able to access the machine
  include v3::admins
# we want to have NTP
  include '::ntp'
# we want to backup up the database
  include v3::backups
# and write the backup to swift
  include v3::duplicity
  include v3::swift
}
# This installs the duplicity package, which allows us, in conjunction with swift, to write backups to swift.
# A write up on duplicity can be found at: https://help.ubuntu.com/community/DuplicityBackupHowto
# Another write up: http://www.linuxuser.co.uk/tutorials/create-secure-remote-backups-using-duplicity-tutorial
#
# But some usefull commmands:
# to list the current files in the swift container named $(hostname):
#     duplicity list-current-files swift://$(hostname)
# to see the version of duplicity:
#     duplicity -V
# to do a dry run of a backup
#     duplicity --dry-run /mnt/backup/ swift://$(hostname)
# to actually do a backup to swift
#     duplicity /mnt/backup/ swift://$(hostname)
# to restore a directory from swift:
#     duplicity swift://$(hostname) /mnt/backup/
# to restore a particular file from swift (say an ldap one):
#     duplicity --file-to-restore ldap/ldap-150317-1409.tar.gz swift://$(hostname) /mnt/backup/ldap/ldap-150317-1409.tar.gz
# to see the status of a backup on swift:
#     duplicity collection-status swift://$(hostname)
# to restore a backup as it was 5 days ago
#     duplicity -t 5D swift://$(hostname) /mnt/backup/
#
# If you get an error: "Exception Versioning for this project requires either an sdist tarball..."
# Then you, most likely, have upgraded the keystone client. And it hasn't upgraded one of its dependencies.
# To fix this issue you then need to run: pip install --upgrade distribute
#
#
class v3::duplicity (
  $work_dir = "/var/tmp",
  $target_dir = "/opt",
){

# should be installed, but...
  if !defined(Package["wget"]) {
    package{ "wget":
      ensure => present,
    }
  }

# should be installed, but...
  if !defined(Package["tar"]) {
    package{ "tar":
      ensure => present,
    }
  }

  $duplicity_requires = [ "gnupg2", "python-lockfile", "librsync-dev", "python-dev" ]

  package { $duplicity_requires:
    ensure => "installed"
  }
  ->
  exec { "download duplicity":
    command => "/usr/bin/wget -O ${work_dir}/duplicity-0.7.01.tar.gz https://launchpad.net/duplicity/0.7-series/0.7.01/+download/duplicity-0.7.01.tar.gz",
    creates => "${work_dir}/duplicity-0.7.01.tar.gz",
    require => Package["wget"],
  }
  ->
  exec { "untar duplicity":
    command   => "/bin/tar -C $target_dir -xvf ${work_dir}/duplicity-0.7.01.tar.gz",
    require   => Package["tar"],
    creates   => "${target_dir}/duplicity-0.7.01",
    subscribe => Exec["download duplicity"],
  }
  ->
  exec { "install duplicity":
    cwd => "${target_dir}/duplicity-0.7.01",
    command => "/usr/bin/python setup.py install",
    subscribe => Exec["untar duplicity"],
  }
}
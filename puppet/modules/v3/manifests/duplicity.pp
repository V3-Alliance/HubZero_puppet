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
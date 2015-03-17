# Could perhaps be done with pgp key? http://budts.be/weblog/2012/08/ssh-authentication-with-your-pgp-key
# note the hubzero admonition:
# If you require additional system accounts, they can be numbered between 500-999 without interfering with hub operations!
class v3::admins (
  $username,
  $user_mail,
  $public_key,
) {

# for our admin's sanity
  package { 'vim':
    ensure => latest,
  }

  user { "${username}":
    comment => "${user_mail}",
    ensure  => present,
    groups  => 'sudo',
  }
  ->
  exec { 'set_account_number':
    command => "/usr/sbin/usermod -u 501 ${username}",
  }

# hubzero_sup
  ssh_authorized_key { "${user_mail}":
    user    => "${username}",
    ensure  => present,
    key     => "$public_key",
    type    => 'rsa',
    require => File["/home/${username}/.ssh"],
  }

  file { "/home/${username}":
    ensure => 'directory',
    owner  => "${username}"
  }

  file { "/home/${username}/.ssh":
    ensure => 'directory',
    owner  => "${username}",
    mode   => '0700',
  }

#'=alan======================='

  user { 'alan':
    comment => 'alan@v3.org.au',
    ensure  => present,
    groups  => 'sudo',
  }
  ->
  exec { 'set_alans_account_number':
    command => '/usr/sbin/usermod -u 502 alan',
  }

# hubzero_sup
  ssh_authorized_key { 'alan@v3.org.au':
    user    => 'alan',
    ensure  => present,
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA7UQmx4+R7ToMxZJyQmfV0xIAQ1v3WYibFHKTmLd830HVOH+iP+vWTVqLd6eCU6gdV7RmnkgJ/LMsYZC48kguyN2YBzA3+vWSexAcrKxlcNchLAbw66fwTy54jzrACRDsJw+6cXUmox/ZKIs3LTsGHRC2ukE4GEO9OMsQOBL/Fhzkh1RcIlV87Tjl4zMg5Ojeav+63qh3jmyvj6DfBoXlvNoxG/9kewI7w132+FQSmQwq8E5WLLG3u989YWC/MOj0EWvkzjUoZD9OPvoxxZcxNFD5K9AZYq/FliGd7as8G8WbYwbf7Nl9xSgLLA8yHKDVaRkuP+qbZjp8yJSsV9YMLQ==',
    type    => 'rsa',
    require => File['/home/alan/.ssh'],
  }

  file { '/home/alan':
    ensure => 'directory',
    owner  => 'alan'
  }

  file { '/home/alan/.ssh':
    ensure => 'directory',
    owner  => 'alan',
    mode   => '0700',
  }

#'=dmicevski======================='

  user { 'dmicevski':
    comment => 'dmicevski@v3.org.au',
    ensure  => present,
    groups  => 'sudo',
  }
  ->
  exec { 'set_dmicevskis_account_number':
    command => '/usr/sbin/usermod -u 503 dmicevski',
  }

  ssh_authorized_key { 'dmicevski@v3.org.au':
    user    => 'dmicevski',
    ensure  => present,
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC4E2LNMEh9l0FO/vhzWnPnoY8Ov7HC8ie6djt+J64sVacLra/kPvUzNCosYVGCn/0QLSlU3fD//VFrGnpKCCgsbwmoLDeQwaSnS1pxluIdFXXySjZ+096hSvF5MrNy4lSPYixRx6vIBPJOWCiP0Tq0T7EpugnPhevpq7ZSXOviwTr6ek2ZmgoQlBb/KFP1+/qxUkQDnd5ylM+Iu6etuNEQ87Oei4TOZg1+6Q75Mo8j0KOyVVPsuOnorlknNA0/B6F+yzSeWgR+RqMD0e5u+FbpEyTgOTSw0OsfBPpfntNAGFarsZQydOgv7EkoL1n0NW0qFAb3Yg4eZV9w3ys5YL5X',
    type    => 'rsa',
    require => File['/home/dmicevski/.ssh'],
  }

  file { '/home/dmicevski':
    ensure => 'directory',
    owner  => 'dmicevski'
  }

  file { '/home/dmicevski/.ssh':
    ensure => 'directory',
    owner  => 'dmicevski',
    mode   => '0700',
  }

#'=melvin======================='

  user { 'melvin':
    comment => 'melvin@v3.org.au',
    ensure  => present,
    groups  => 'sudo',
  }
  ->
  exec { 'set_melvins_account_number':
    command => '/usr/sbin/usermod -u 504 melvin',
  }

  ssh_authorized_key { 'melvin@v3.org.au':
    user    => 'melvin',
    ensure  => present,
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDIAxgXVuCzQavkX5WqDuo9zJ+PvI3dxGsh4mPPkwqQ4eotKNYnXiWmj9iDdIkFkWCTF2sy1oNhiR4U5tYQJJEEtmYl9w94aM0fnlB+0k7JTaFsMfk41Q2PoHYa0oLDMoZ2CFKTyKVCJDANjXGGYfQUhOz3W0q25KZmTEMfErwJwhMmEiyliZgGkjUHcKfEDBMaN/Dtn4t52RvDxCPs57zzT8A91XaxuqAKhdra8MZVigu6WStXVUqSya3C6TQo7t7Sj3JLldQSu+G4uDYAjP/22KG7b0+HcyyVCRgihky55vd0fipCHStIqXgNsAnJjbZM3ZiNJEn5l6FdMWFQvINV',
    type    => 'rsa',
    require => File['/home/melvin/.ssh'],
  }

  file { '/home/melvin':
    ensure => 'directory',
    owner  => 'melvin'
  }

  file { '/home/melvin/.ssh':
    ensure => 'directory',
    owner  => 'melvin',
    mode   => '0700',
  }

#'=jared======================='

  user { 'jwinton':
    comment => 'jwinton@v3.org.au',
    ensure  => present,
    groups  => 'sudo',
  }
  ->
  exec { 'set_jwintons_account_number':
    command => '/usr/sbin/usermod -u 505 jwinton',
  }

  ssh_authorized_key { 'jwinton@v3.org.au':
    user    => 'jwinton',
    ensure  => present,
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDdjmhw3hUzWtT8QuGTI3ez7apV0rgPFEOT6rTl7cRxgogIEv6ATHzXsSsU4GNuq0yMLaOcAXjOXr2S5lHhkNrit8s0QOKcaj0uS7jLAmnKLN8HhfvEWErWt2A3H36+LEgQyDGOsndV915V6goEwG4bXqNEOe2Annj6F5t2R3UI9P4cG/1ydKkP7w2XCiYPfPYMkqObJG8+GdPhqBCR4BrFNphh/qBQYrakFbBqpkOzdhk++rdWTK8qu0nQozmMUEg83TE1xF6LKmt8ApiTixYowBw+ed0DBlqe8t+eoFLflLdNnYfxJpQ2fUjyd3RDhNg3dkR5inIgwv9j6BKT0R55',
    type    => 'rsa',
    require => File['/home/jwinton/.ssh'],
  }

  file { '/home/jwinton':
    ensure => 'directory',
    owner  => 'jwinton'
  }

  file { '/home/jwinton/.ssh':
    ensure => 'directory',
    owner  => 'jwinton',
    mode   => '0700',
  }

#'========================'

  file { '/etc/sudoers.d/sudogroup':
    ensure => file,
    owner  => root,
    mode   => '0440',
    source => 'puppet:///modules/v3/sudogroup',
  }
}

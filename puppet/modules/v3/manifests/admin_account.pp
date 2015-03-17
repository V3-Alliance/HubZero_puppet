# Could perhaps be done with pgp key? http://budts.be/weblog/2012/08/ssh-authentication-with-your-pgp-key
# note the hubzero admonition:
# If you require additional system accounts, they can be numbered between 500-999 without interfering with hub operations!
class v3::admin_account (
  $username,
  $user_mail,
  $user_id,
  $public_key,
) {

  user { "${username}":
    comment => "${user_mail}",
    ensure  => present,
    groups  => 'sudo',
  }
  ->
  exec { 'set_account_number':
    command => "/usr/sbin/usermod -u ${user_id} ${username}",
  }

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

  file { '/etc/sudoers.d/sudogroup':
    ensure => file,
    owner  => root,
    mode   => '0440',
    source => 'puppet:///modules/v3/sudogroup',
  }
}

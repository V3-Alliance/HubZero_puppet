# Could perhaps be done with pgp key? http://budts.be/weblog/2012/08/ssh-authentication-with-your-pgp-key
class v3::admins {

# for each potential admin, copy the the section below up to the '========================' line and customize.

  user { 'martin':
    comment => 'mpaulo@v3.org.au',
    ensure  => present,
    groups  => 'sudo',
  }

# hubzero_sup
# generated by:  ssh-keygen -t rsa -C "mpaulo@v3.org.au" then copying the public portion to the key below.
  ssh_authorized_key { 'mpaulo@v3.org.au':
    user    => 'martin',
    ensure  => present,
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDMW4zLFHV0j8GgVG/5yebcs95gaCBwgv+YfTLAok/dY77LoqVGhw+4vP3A03qnc0l08Dq5BJz8x6i4JSmUgYS+tMh7MIopR6VsG3jDwt7cViJUKicWEUCwF0M8RRtdLAtVvbv3o3DrhLcEqzpGE4yO3wIYkFzFvU+wmoA4IJt95ZK3z/VXtljUs4bB8XeYfAf+gGei/y9sNcn5388LDr5Wkqay/2fXmllC7yAxeNdD5pOsDI1/xwFBYCG5wmatsJvKL5zpWQPm1LWQ0uCPZzn40t5KsFGE5puxs6uvVSpmn3k/u7qlMfYhpDIXhn63yw9Kzi9qL2PFVsbmk7Y6Z+qp',
    type    => 'rsa',
    require => File['/home/martin/.ssh'],
  }

  file { '/home/martin':
    ensure => 'directory',
    owner  => 'martin'
  }

  file { '/home/martin/.ssh':
    ensure => 'directory',
    owner  => 'martin',
    mode   => '0700',
  }

#'========================'

  user { 'alan':
    comment => 'alan@v3.org.au',
    ensure  => present,
    groups  => 'sudo',
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

#'========================'

  file { '/etc/sudoers.d/sudogroup':
    ensure => file,
    owner  => root,
    mode   => '0440',
    source => 'puppet:///modules/V3/sudogroup',
  }
}

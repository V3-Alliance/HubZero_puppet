#/etc/puppet/modules/nrpe/manifests/absolutememory.pp


class nrpe::absolutememory {

    file {"/etc/nagios-plugins/config/absolutememory.cfg":
      ensure    => file,
      source    => "puppet:///modules/nrpe/absolutememory.cfg",
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
      mode      => '0644',
    }

    file {"/etc/nagios/nrpe.d/check_absolutememory.cfg":
      ensure    => file,
      source    => "puppet:///modules/nrpe/check_absolutememory.cfg",
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
      mode      => '0644',
    }

    file {"/usr/lib/nagios/plugins/absolutememorynagios.py":
      ensure    => file,
      source    => "puppet:///modules/nrpe/absolutememorynagios.py",
      mode      => '0755',
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
    }
}

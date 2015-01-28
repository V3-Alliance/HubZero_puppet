#/etc/puppet/modules/nrpe/manifests/apachememory.pp


class nrpe::apachememory {

    # the script needs the bc package to be installed.
    file {"/etc/nagios-plugins/config/apachememory.cfg":
      ensure    => file,
      source    => "puppet:///modules/nrpe/apachememory.cfg",
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
      mode      => '0644',
    }

    file {"/etc/nagios/nrpe.d/check_apachememory.cfg":
      ensure    => file,
      source    => "puppet:///modules/nrpe/check_apachememory.cfg",
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
      mode      => '0644',
    }

    file {"/usr/lib/nagios/plugins/check_cpu_proc.sh":
      ensure    => file,
      source    => "puppet:///modules/nrpe/check_cpu_proc.sh",
      mode      => '0755',
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
    }
}

		

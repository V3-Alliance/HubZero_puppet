#/etc/puppet/modules/nrpe/manifests/init.pp


class nrpe ( 
  $nagiosservers = $nrpe::nagiosservers, 
) {

    package {"nagios-nrpe-server":
      ensure  => installed,
    }

    #required for server memory and absolutememory nagios checks.
    package {"python-psutil":
      ensure  => installed,
    }

    file {"/etc/nagios/nrpe.cfg":
      ensure    => file,
      content    => template("nrpe/nrpe.cfg.erb"),
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
    }

    service {"nagios-nrpe-server":
      ensure  => running,
      enable  => true,
      require => Package['nagios-nrpe-server'],
    }

    #The nagios user needs to read hosts.deny, which 
    #it does not have permission to do by default.
    #If it does not have this permission, it says
    #that the access is denied by tcpwrapper, even
    #if not specified.
    file {"/etc/hosts.deny":
      mode   => '0644',
    }

    file {"/etc/nagios/nrpe.d/check_ntp_time.cfg":
      ensure    => file,
      content   => template("nrpe/check_ntp_time.cfg.erb"),
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
    }

    file {"/etc/nagios/nrpe.d/check_all_disks.cfg":
      ensure    => file,
      content   => template("nrpe/check_all_disks.cfg.erb"),
      require   => Package ['nagios-nrpe-server'],
      notify    => Service ['nagios-nrpe-server'],
    }

}

#/etc/puppet/modules/nrpe/manifests/init.pp
# On the nagios server:
#   The matching file for this setup is:
#       /etc/nagios/conf.d/hubzero-martin.cfg
#   To debug what's going on:
#       http://support.nagios.com/forum/viewtopic.php?f=7&t=5807&start=0
#   The command to check any changes to it is:
#       service nagios checkconfig
#   The command to restart nagios after any config changes is:
#       systemctl restart nagios
#

class nrpe ( 
  $nagiosservers = $nrpe::nagiosservers, 
) {

    # if we want this to log to its own file:
    #    http://www.charlesjudith.com/2014/03/11/create-a-log-file-for-nrpe/
    # if we want to debug what's going on:
    #    http://www.lowlevelmanager.com/2012/05/debugging-nagios-remote-nrpe-commands.html
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

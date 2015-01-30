To synchronise the ntp service on the target machine:

    sudo service ntp stop
    sudo ntpd -gq
    sudo service ntp start

To test the ntp service via the nagious plugin on the target machine:

    /usr/lib/nagios/plugins/check_ntp_time -H <ip> -v

where <ip> is the ip number of the target machine.
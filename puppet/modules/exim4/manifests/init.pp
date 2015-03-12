# <h2>Exim4</h2>
# <p>Used by all versions of HubZero
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.exim4">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.mysql">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.mysql">1.3 Install Instructions</a>
# </ul>
# <p>Based on:
# <ul>
#   <li><a href="http://projects.puppetlabs.com/projects/1/wiki/debian_preseed_patterns">Debian preseed patterns</a>
#   <li><a href="http://blogs.cae.tntech.edu/mwr/2008/02/05/stupid-puppet-trick-agreeing-to-the-sun-java-license-with-debconf-preseeds-and-puppet/">
#          Dealing with the sun licence with debconf and preseeds</a>
# </ul>
# <p>Also note that the pre-seeding only works once: when the package is installed. After that, you have to
# edit the config file directly and run <pre>update-exim4-config</pre> or do a <pre>dpkg-reconfigure exim4-config</pre>
# <p>See <a href="http://serverfault.com/questions/614895/debconf-is-ignoring-my-default-anwsers">
#           debconf is ignoring my default anwsers.</a>
# <p>Given the above, changes need to be made by running:
# <pre>dpkg-reconfigure exim4-config</pre>
# <p>The
# <pre>exim -bV command</pre>
# <p>gives useful information on exim's setup.
# <p>Also see: <a href="https://www.digitalocean.com/community/tutorials/how-to-install-the-send-only-mail-server-exim-on-ubuntu-12-04">
#     how to install the send only mail server exim on ubuntu 12-04</a>
# <p>To test on the command line, enter the following (where someone@target.com is your email address!):
# <pre>$ echo "This is a test message." | mail -s "Hello from hubzero" someone@target.com</pre>
# <p>To send a file via the command line, enter the following (where someone@target.com is your email address!):
# <pre>$ mail -s "A filey gift" someone@target.com < /a/path/to/some/file</pre>
class exim4 (
  $fqdn, $postmaster
){

  file { "/var/cache/debconf/exim4.seeds":
    content => template ('exim4/exim4.seeds.erb'),
    ensure  => present;
  }
  ->
  package { "exim4":
    require      => File ["/var/cache/debconf/exim4.seeds"],
    responsefile => "/var/cache/debconf/exim4.seeds",
    ensure       => latest;
  }
  # There is an oddity with the erb file not breaking the 'internet' setting for the application if variables are
  # embedded in it. This sledgehammer forces it to internet.
  ->
  exec { "change exim4 config to internet":
    command =>"/bin/sed -i \"s/dc_eximconfig_configtype=.*/dc_eximconfig_configtype='internet'/\" /etc/exim4/update-exim4.conf.conf",
  }
  ->
  exec { "reconfigure exim4":
    command=>'/usr/sbin/dpkg-reconfigure exim4-config -fnoninteractive'
  }

}


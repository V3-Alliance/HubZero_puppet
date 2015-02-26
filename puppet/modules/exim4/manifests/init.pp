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
# <p> Also see: <a href="https://www.digitalocean.com/community/tutorials/how-to-install-the-send-only-mail-server-exim-on-ubuntu-12-04">
#     how to install the send only mail server exim on ubuntu 12-04</a>
# <p>After rebooting, it would seem that sometimes the exim4 package resets its configuration and no longer mails out.
# The quick fix is to  run:
# <pre>dpkg-reconfigure exim4-config</pre>
# and select the "internet site" option.
# <p>The
# <pre>exim -bV command</pre>
# <p>gives useful information on exim's setup.
# <p>To test on the command line, enter the following (where someone@target.com is your email address!):
# <pre>$ echo “This is a test message.” | mail -s “Hello from hubzero” someone@target.com</pre>
# <p>To send a file via the command line, enter the following (where someone@target.com is your email address!):
# <pre>$ mail -s “A filey gift” someone@target.com < /a/path/to/some/file</pre>
class exim4 (
  $fqdn
){

  package { "exim4":
    require      => File ["/var/cache/debconf/exim4.seeds"],
    responsefile => "/var/cache/debconf/exim4.seeds",
    ensure       => latest;
  }

  file { "/var/cache/debconf/exim4.seeds":
    content => template ('exim4/exim4.seeds.erb'),
    ensure  => present;
  }

}


# <h2>Telequotad</h2>
# <p>Install and configure telequotad.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.telequotad">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.telequotad">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.telequotad">1.3 Install Instructions</a>
# </ul>
# <p>The sed magic is from the
# <a href="http://askubuntu.com/questions/443333/add-strings-to-a-file-with-commands">Ubuntu forums</a>
class telequotad (
  $version
){

  package { "hubzero-telequotad":
    ensure => latest,
  }

  exec { "add quota to filesystem":
    command      => "sudo sed -i.old -r '/[ \\t]\\/[ \\t]/{s/(ext4[\\t ]*)([^\\t ]*)/\\1\\2,quota/}' /etc/fstab",
    require      => Package["hubzero-telequotad"],
  }

  exec { "remount filesystem":
    command      => "mount -oremount /",
    require      => Exec["add quota to filesystem"],
  }

  exec { "restart quota":
    command      => "mount -o remount /",
    require      => Exec["remount filesystem"],
  }

  if ($version=="1.3") {
    exec { "enable telequotad":
      command      => "hzcms configure telequotad --enable",
      require      => [
        Package ["hubzero-cms"],
        Exec["restart quota"]],
    }
  }
}
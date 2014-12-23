# <h2>Workspac</h2>
# <p>Install and configure the HubZero Workspace.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.workspace">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.workspace">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.workspace">1.3 Install Instructions</a>
# </ul>
class workspace {

  package { "hubzero-app":
    ensure => latest,
  }

  package { "hubzero-app-workspace":
    ensure => latest,
    require      => Package["hubzero-app"],
  }

  exec { "initialize workspace":
    command      => "/usr/bin/hubzero-app install --publish /usr/share/hubzero/apps/workspace-1.3.hza",
    require      => Package["hubzero-app-workspace"]
  }
}
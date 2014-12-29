#<h2>Maxwell Service</h2>
# <p>Installs the HubZero Maxwell service.
# <p>See:
# <ul>
#   <li><a href="https://hubzero.org/documentation/1.1.0/installation/Setup.maxwell_service">1.1 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.2.2/installation/Setup.maxwell_service">1.2 Install Instructions</a>
#   <li><a href="https://hubzero.org/documentation/1.3.0/installation/installdeb.maxwell_service">1.3 Install Instructions</a>
# </ul>
class maxwell-service (
  $version
){

  case $version {
    1.1: { $template_command =  "/usr/bin/mkvztemplate amd64 squeeze manny" }
    1.2: { $template_command =  "/usr/bin/mkvztemplate amd64 wheezy shira" }
    default : { $template_command =  "/usr/bin/mkvztemplate amd64 wheezy diego" }
  }

  package { "hubzero-mw-service":
    ensure => latest,
  }
  ->
  exec { "create template":
    command      => $template_command,
  #default timeout is 300 seconds, which is too short for this command under 1.1...
  # timeout is symptomatic of a deeper problem...
    timeout      => 1800,
    require      => Package["hubzero-mw-service"],
  }
  ->
  exec { "enable maxwell":
    command      => "/usr/bin/hzcms configure mw-service --enable",
    require      => [Package["hubzero-mw-service"], Package["hubzero-cms"], Exec["initialize openvz"]],
  }

}
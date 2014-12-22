#<h2>Maxwell Service</h2>
#<p><b>See:</b> <a href="https://hubzero.org/documentation/1.1.0/installation/Setup.maxwell_service">https://hubzero.org/documentation/1.1.0/installation/Setup.maxwell_service</a>
class maxwell-service {

  package { "hubzero-mw-service":
    ensure => latest,
  }
  ->
  exec { "create template":
    command      => "/usr/bin/mkvztemplate amd64 squeeze manny",
    #default timeout is 300 seconds, which is too short for this command...
    # timeout is symptomatic of a deeper problem...
    timeout      => 1800,
    require      => Package["hubzero-mw-service"],
  }
  ->
  exec { "enable maxwell":
    command      => "/usr/bin/hzcms configure mw-service --enable",
    require      => [Package["hubzero-mw-service"], Package["hubzero-cms"]],
  }

}
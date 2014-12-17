#http://serverfault.com/questions/611200/puppet-how-to-run-an-exec-only-if-puppet-has-made-changes
exec { "do reboot":
  command => reboot,
#  subscribe   => Stage['pre','main','aux'],
#  refreshonly => true,
}
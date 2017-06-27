# "WSMan from Linux/MacOS to Linux with basic authentication with omicli with bad password over https should throw exception"
$hostname = "psl-cent7x64-04"
$User = "root"
$badPassword = "badPassword"
$Port = "5986"
$result = /opt/omi/bin/omicli id -u $User -p $badPassword --auth Basic --hostname $hostname --port $Port --encryption https
$result # Should Match 'error'


# "WSMan from Linux/MacOS to Linux with basic authentication with omicli with bad password over https should throw exception"
$hostname = "hostname"
$User = "root"
$badPassword = "badPassword"
$Port = "5986"
$result = /opt/omi/bin/omicli id -u $User -p $badPassword --auth Basic --hostname $hostname --port $Port --encryption https
$result # Should Match 'error'
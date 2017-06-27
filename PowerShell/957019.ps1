# "WSMan from Linux/MacOS to Windows with basic authentication with omicli with invalid username over http should throw exception"
$hostname = $WindowsHostName
$User = $WindowsUserName
$windowsPasswordString = "invalidPassword" 
$HTTPPort=5985
$result = /opt/omi/bin/omicli ei root/cimv2 Win32_SystemOperatingSystem -u $User -p $windowsPasswordString --auth Basic --hostname $hostname --port $HTTPPort --encryption none
$result # Should Match 'error' 

$hostname = $WindowsHostName
$User = $WindowsUserName
$windowsPasswordString=$windowsPasswordString
# 957031:<Negotiate><HTTP><Linux/Mac-Windows>: Omicli with valid credentials should work.
$hostname = $WindowsHostName
$User = $WindowsUserName
$windowsPasswordString = $windowsPasswordString
$HTTPPort = 5985
$result = /opt/omi/bin/omicli ei root/cimv2 Win32_SystemOperatingSystem -u $User -p $windowsPasswordString --auth NegoWithCreds --hostname $hostname --port $HTTPPort --encryption none
$result # Should Not BeNullOrEmpty
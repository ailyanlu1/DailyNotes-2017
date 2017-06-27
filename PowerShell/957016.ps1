# "WSMan from Linux/MacOS to Windows with basic authentication by omicli over http should work" -Skip:($IsWindows) {
$hostname = $hostname
$User = "Administrator"
$windowsPasswordString ="Pine#Tar*9“
$HTTPPort=5985
$result = /opt/omi/bin/omicli ei root/cimv2 Win32_SystemOperatingSystem -u $User -p $windowsPasswordString --auth Basic --hostname $hostname --port $HTTPPort --encryption none
$result # Should Not BeNullOrEmpty


/opt/omi/bin/omicli ei root/cimv2 Win32_SystemOperatingSystem -u "Administrator" -p "Pine#Tar*9" --auth Basic --hostname "PSRP-W12R2-01" --port "5985" --encryption none


$hostname = "PSRP-W12R2-01"
$User = "Administrator"
$password="Pine#Tar*9“


# WSMan from Linux/MacOS to Windows with Kerberos authentication by omicli over http should word
$hostname = "Winhostname"
$KDCUser="omi_test@SCX.COM"
$KDCPasswordString="omi_test1"
$HTTPPort=5985
$result=/opt/omi/bin/omicli --hostname PSRP-W12R2-01 -u omi_test@SCX.COM -p omi_test1 --auth Kerberos --port 5985  ei root/cimv2 Win32_Share
$result
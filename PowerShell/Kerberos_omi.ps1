# WSMan from Linux/MacOS to Windows with Kerberos authentication by omicli over http should word
$hostname = "Winhostname"
$KDCUser="omi_test@SCX.COM"
$KDCPasswordString="omi_test1"
$HTTPPort=5985
$result=/opt/omi/bin/omicli --hostname PSRP-W12R2-01 -u omi_test@SCX.COM -p omi_test1 --auth Kerberos --port 5985  ei root/cimv2 Win32_Share
$result
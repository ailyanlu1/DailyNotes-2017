# "WSMan from Linux to Linux with negotiate authentication with omicli over https should work"
$hostname = $LinuxHostName
$User = $LinuxUserName
$linuxPasswordString = "Pine#Tar*9"
$Port = "5986"
if($IsLinux -Or $IsOSX)
{
    $result = /opt/omi/bin/omicli id -u "$hostname\$User" -p $linuxPasswordString --auth NegoWithCreds --hostname $hostname --port $Port --encryption https
    $result #Should Not BeNullOrEmpty
}


$hostname = "psl-cent7x64-04"
$User = "root"
$linuxPasswordString = "Pine#Tar*9"
$Port = "5986"


# "WSMan from Linux to Linux with negotiate authentication with omicli over https should work"
$hostname = "psl-cent7x64-04"
$User = "root"
$linuxPasswordString = "Pine#Tar*9"
$Port = "5986"
if($IsLinux -Or $IsOSX)
{
    $result = /opt/omi/bin/omicli id -u "$hostname\$User" -p $linuxPasswordString --auth NegoWithCreds --hostname $hostname --port $Port --encryption https
    $result #Should Not BeNullOrEmpty
}

$hostname = $LinuxHostName
$User = $LinuxUserName
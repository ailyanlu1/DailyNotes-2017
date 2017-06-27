# "WSMan from Linux/MacOS to Linux with basic authentication with omicli over https should work"
$hostname = "psl-cent7x64-04"
$User = "root"
$password = "Pine#Tar*9"
$Port = "5986"
if($IsLinux -Or $IsOSX)
{
    $result = /opt/omi/bin/omicli id -u $User -p $password --auth Basic --hostname $hostname --port $Port --encryption https
    $result #Should Not BeNullOrEmpty
}


$hostname = $LinuxHostName
$User = $LinuxUserName

# "WSMan from Linux/MacOS to Linux with basic authentication with omicli over https should work"
$hostname = $LinuxHostName
$User = $LinuxUserName
$password = $LinuxPassword
$Port = $port
if($IsLinux -Or $IsOSX)
{
    $result = /opt/omi/bin/omicli id -u $User -p $password --auth Basic --hostname $hostname --port $Port --encryption https
    $result #Should Not BeNullOrEmpty
}

$hostname = "psl-cent7x64-04"
$User = "root"
$password = "Pine#Tar*9"

$hostname = "PSRP-W12R2-01"
$User = "Administrator"
$password="Pine#Tar*9“


# "WSMan from Linux/MacOS to Linux with basic authentication with omicli over https should work"
$hostname = "psl-cent7x64-04"
$User = "root"
$password = "Pine#Tar*9"
$Port = '5986'
if($IsLinux -Or $IsOSX)
{
    $result = /opt/omi/bin/omicli id -u 'root' -p 'Pine#Tar*9' --auth Basic --hostname 'psl-cent7x64-04' --port '5986' --encryption https
    $result #Should Not BeNullOrEmpty
}
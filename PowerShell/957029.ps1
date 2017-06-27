# 957029:<Negotiate><HTTPS><Linux/Mac-Linux>: Omicli with invalid password should throw exception.
$hostname = $LinuxHostName
$User = $LinuxUserName
$badPassword = "badPassword"
$Port = "5986"
try
{
    $result = /opt/omi/bin/omicli id -u $User -p $badPassword --auth NegoWithCreds  --hostname $hostname --port $Port --encryption https
}
catch
{
    $result # Should Match 'error'
}
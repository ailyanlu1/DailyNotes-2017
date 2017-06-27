# 957034:<Negotiate><HTTP><Linux/Mac-Windows>: Omicli with invalid username should throw exception.
$hostname = $LinuxHostName
$User = $LinuxUsername
$linuxPasswordString = "badPassword"
$Port = "5985"
try
{
    $result = /opt/omi/bin/omicli id -u $User -p $linuxPasswordString --auth Basic --hostname $hostname --port $Port --encryption https
}
    catch
{
    $result # Should Match 'error'
}



# 957035:<Negotiate><HTTP><Linux-Windows>: Omicli with invalid password should throw exception.
$hostname = $LinuxHostName
$User = $LinuxUsername
$linuxPasswordString = "badPassword"
$Port = "5985"
try
{
    $result = /opt/omi/bin/omicli id -u $User -p $linuxPasswordString --auth Basic --hostname $hostname --port $Port --encryption https
}
    catch
{
    $result # Should Match 'error'
}
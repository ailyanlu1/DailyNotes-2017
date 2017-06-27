# "WSMan from Windows to Linux with basic authentication with winrm with bad password over https should throw exception"
$hostname = $LinuxHostName
$badPassword = "badPassword"
$User = $LinuxUserName
$Port = "5986"
try
{
    winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:Basic -u:$User -p:$badPassword -skipcncheck -skipcacheck -encoding:utf-8
}

catch
{
    $_.FullyQualifiedErrorId #Should be "NativeCommandError"
}


# "WSMan from Windows to Linux with basic authentication with winrm with bad password over https should throw exception"

try
{
    winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:Basic -u:$User -p:$badPassword -skipcncheck -skipcacheck -encoding:utf-8
}

catch
{
    $_.FullyQualifiedErrorId #Should be "NativeCommandError"
}


$hostname = "psl-cent7x64-04"
$User = "root"
$password = "Pine#Tar*9"

winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://"psl-cent7x64-04":5986 -auth:Basic -u:"psl-cent07x64-04" -p:"badPassword" -skipcncheck -skipcacheck -encoding:utf-8

winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://"psl-cent7x64-04":5986 -auth:Basic -u:"psl-cent7x64-04\root" -p:'Pine#Tar*9' -skipcncheck -skipcacheck -encoding:utf-8
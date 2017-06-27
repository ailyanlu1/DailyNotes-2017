#"PowerShell from Linux/MacOS to Linux with basic authentication with bad password over https should throw exception" 
$hostname = $LinuxHostName
$User = $badUserName
$password=“badPassword”
$PWord = Convertto-SecureString $password -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
try
{
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption -ErrorAction Stop
Invoke-Command -Session $mySession {Get-Host}
}
catch
{
# it maybe a error message issue on Linux/MacOS, just keep it now.
$_.FullyQualifiedErrorId
#Should be "2,PSSessionOpenFailed"
}



# "WSMan from Windows to Linux with basic authentication with winrm with bad username over https should throw exception"
$hostname = "psl-cent7x64-04"
$User = "badUserName"
$linuxPasswordString = "Pine#Tar*9"
try
{
    winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://psl-cent7x64-04:5986 -auth:Basic -u:"root" -p:'Pine#Tar*9' -skipcncheck -skipcacheck -encoding:utf-8
}
catch
{

    $_.FullyQualifiedErrorId # Should be "NativeCommandError"
}



winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://psl-cent7x64-04:5986 -auth:Basic -u:"psl-cent7x64-04\root" -p:'Pine#Tar*9' -skipcncheck -skipcacheck -encoding:utf-8




winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:Basic -u:"$hostname\$User" -p:$linuxPasswordString -skipcncheck -skipcacheck -encoding:utf-8


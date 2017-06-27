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




# "WSMan from Linux/MacOS to Linux with basic authentication with omicli with bad username over https should throw exception" -Pending:$true {
$hostname = "psl-cent7x64-04"
$User = "badUserName"
$linuxPasswordString = "Pine#Tar*9"
$Port = "5986"
$result = /opt/omi/bin/omicli id -u $User -p $linuxPasswordString --auth Basic --hostname $hostname --port $Port --encryption https
$result # Should Match 'error'
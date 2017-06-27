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
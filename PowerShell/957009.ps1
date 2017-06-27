#"PowerShell from Windows to Linux with basic authentication with bad username over https should throw exception"
$hostname = $LinuxHostName
$User = $badUserName
$password=$linuxPasswordString
$PWord = Convertto-SecureString $password -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User,$PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
try
{
    $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption -ErrorAction Stop
    Invoke-Command -Session $mySession {Get-Host}
}
catch
{
    $_.FullyQualifiedErrorId
    #Should be "AccessDenied,PSSessionOpenFailed"
}
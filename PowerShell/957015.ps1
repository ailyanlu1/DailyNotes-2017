#"PowerShell from Linux/MacOS to Windows with basic authentication over http should work"
$hostname = $WindowsHostName
$User = $WindowsUserName
$windowsPasswordString=$windowsPasswordString
$PWord = Convertto-SecureString $windowsPasswordString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -SessionOption $sessionOption
$result = Invoke-Command -Session $mySession {Get-Host}
$result
#result Should Not BeNullOrEmpty
# Linux/MacOS to Windows: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
if($IsWindows)
{
     Get-PSSession|Disconnect-PSSession
}
     Get-PSSession|Remove-PSSession
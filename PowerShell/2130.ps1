#957021 "PowerShell from Windows/Linux/MacOS to Linux with negotiate authentication over https should work"
$hostname = $LinuxHostName
$User = $LinuxUserName
$password=$linuxPasswordString
$PWord = convertto-securestring $password -asplaintext -force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User",$PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption
$result = Invoke-Command -Session $mySession {Get-Host}
$result.PSComputerName # Should Not BeNullOrEmpty
# Linux/MacOS to Linux: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
if($IsWindows)
{

    Get-PSSession|Disconnect-PSSession
}
    Get-PSSession|Remove-PSSession



#957030 "PowerShell from Linux/MacOS to Windows with negotiate authentication over http should work"
$hostname = $WindowsHostName
$User = $WindowsUserName
$windowsPasswordString = $windowsPasswordString
$PWord = Convertto-SecureString $windowsPasswordString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User", $PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -SessionOption $sessionOption
$result = Invoke-Command -Session $mySession {Get-Host}
$result # Should Not BeNullOrEmpty
# Linux/MacOS to Windows: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
if($IsWindows)
{

    Get-PSSession|Disconnect-PSSession
}
    Get-PSSession|Remove-PSSession




#"PowerShell from Windows/Linux/MacOS to Linux with negotiate authentication over https should work"
$hostname = "PSRP-W12R2-01"
$User = "Administrator"
$password="Pine#Tar*9“
$PWord = convertto-securestring $password -asplaintext -force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User",$PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption
$result = Invoke-Command -Session $mySession {Get-Host}
$result.PSComputerName  #Should Not BeNullOrEmpty
# Linux/MacOS to Linux: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
if($IsWindows)
{
Get-PSSession|Disconnect-PSSession
}
Get-PSSession|Remove-PSSession




#PowerShell from Windows/Linux/MacOS to Linux with negotiate authentication over https should work
$hostname = $LinuxHostName
$User = $LinuxUserName
$password=$linuxPasswordString
$PWord = convertto-securestring $password -asplaintext -force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User",$PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption
$result = Invoke-Command -Session $mySession {Get-Host}
$result.PSComputerName #Should Not BeNullOrEmpty
# Linux/MacOS to Linux: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
if($IsWindows)
{
    Get-PSSession|Disconnect-PSSession

}

    Get-PSSession|Remove-PSSession












$hostname = "PSRP-W12R2-01"
$User = "Administrator"
$password = "Pine#Tar*9"
$PWord = convertto-securestring $password -asplaintext -force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User",$PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -SessionOption $sessionOption
Invoke-Command -Session $mySession {Get-Host}
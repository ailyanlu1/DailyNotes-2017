# 957032:<Negotiate><HTTP><Windows/Linux/Mac-Windows>: Powershell with invalid username should throw exception.
$hostname = $WindowsHostName
$User = $badUserName
$windowsPasswordString = $windowsPasswordString
$PWord = Convertto-SecureString $windowsPasswordString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User", $PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
try
{
    $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption -ErrorAction Stop
    Invoke-Command -Session $mySession {Get-Host}
}
    catch
{
    $_.FullyQualifiedErrorId # Should be "1,PSSessionOpenFailed"
}
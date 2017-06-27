$hostname = "PSRP-W12R2-01"
$User = "Administrator"
$windowsPasswordString= "Pine#Tar*9"
$PWord = Convertto-SecureString $windowsPasswordString -AsPlainText -Force 
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord 
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck 
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -SessionOption $sessionOption 
$result = Invoke-Command -Session $mySession {Get-Host}
echo $result
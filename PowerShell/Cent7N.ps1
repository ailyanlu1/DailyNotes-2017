$hostname = "psl-cent7x64-04"
$User = "root"
$password = "Pine#Tar*9"
$PWord = convertto-securestring $password -asplaintext -force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User",$PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption
$result = Invoke-Command -Session $mySession {Get-Host}
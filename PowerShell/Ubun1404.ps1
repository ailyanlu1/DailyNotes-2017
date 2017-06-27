$hostname = "psl-ub14x64-04"
$User = "root"
$password="Pine#Tar*9"
$PWord = convertto-securestring $password -asplaintext -force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User,$PWord
$sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
$mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption
Invoke-Command -Session $mySession {Get-Host}


$hostname = "psl-ub14x64-04"
$User = "root"
$password="Pine#Tar*9"


$hostname = $LinuxHostName
$User = $badUserName
$password=$linuxPasswordString
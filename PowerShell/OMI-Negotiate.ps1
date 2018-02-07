$PWord = convertto-securestring '0******7' -asplaintext -force
$Cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList omi-cent7x64-t1\root, $PWord
$CimSessionOption = New-CimSessionOption -UseSsl:$false -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true -NoEncryption
$CimSession=New-CimSession -Credential:$Cred -ComputerName:omi-cent7x64-t1 -Port:5985 -Authentication:Negotiate -SessionOption:$CimSessionOption
Register-CimIndicationEvent -ClassName 'XYZ_DiskFault' -CimSession $CimSession -SourceIdentifier 'DiskFaultTest:omi-cent7x64-t1'
Start-Sleep -s 3
(Get-Event -SourceIdentifier 'DiskFaultTest:omi-cent7x64-t1')[0].SourceEventArgs.NewEvent

Remove-Event -SourceIdentifier 'DiskFaultTest:omi-cent7x64-t1'
Unregister-Event -SourceIdentifier 'DiskFaultTest:omi-cent7x64-t1'

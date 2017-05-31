#set code password
$Credential = Get-Credential
$credential.Password | ConvertFrom-SecureString | Set-Content $env:userprofile\password.txt

$UserName = “root”
$PassphraseFile=”$env:userprofile\password.txt”
$ourEncryptPw =  Get-Content $PassphraseFile | ConvertTo-SecureString
$ourCreds =  New-Object System.Management.Automation.PSCredential ($UserName, $ourEncryptPw)
$ourDecryptPw = $ourCreds.GetNetworkCredential().Password
echo $ourDecryptPw

# "WSMan from Windows to Linux with negotiate authentication with winrm over https should work"
$hostname = "psl-cent7x64-04"
$User = "root"
$linuxPasswordString = “Pine#Tar*9”
$result = winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://psl-cent7x64-04:5986 -auth:negotiate -u:"psl-cent7x64-04\root" -p:"Pine#Tar*9" -skipcncheck -skipcacheck -encoding:utf-8
# "$result | Should Not BeNullOrEmpty" not works here, it is a Pester bug, so just use Length verificaiton now
$result.Length # Should BeGreaterThan 1


# "WSMan from Windows to Linux with negotiate authentication with winrm over https should work"
$hostname = "psl-cent7x64-04"
$User = "root"
$linuxPasswordString = “Pine#Tar*9”
$result = winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:negotiate -u:"$hostname\$User" -p:$linuxPasswordString -skipcncheck -skipcacheck -encoding:utf-8
# "$result | Should Not BeNullOrEmpty" not works here, it is a Pester bug, so just use Length verificaiton now
$result.Length|Should BeGreaterThan 1


winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:negotiate -u:"$hostname\$User" -p:"Pine#Tar*9" -skipcncheck -skipcacheck -encoding:utf-8


# "WSMan from Windows to Linux with negotiate authentication with winrm over https should work"
$hostname = $LinuxHostName
$User = $LinuxUserName
$linuxPasswordString = $linuxPasswordString
$Port = "5986"
$result = winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:negotiate -u:"$hostname\$User" -p:$badPassword -skipcncheck -skipcacheck -encoding:utf-8
# "$result | Should Not BeNullOrEmpty" not works here, it is a Pester bug, so just use Length verificaiton now
$result.Length # Should BeGreaterThan 1
# "WSMan from Windows to Linux with basic authentication with winrm over https should work"
$hostname = "psl-cent7x64-04"
$User = "root"
$linuxPasswordString = "Pine#Tar*9"
winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://OMITST-UBUN16-01.SCX.COM:5986 -auth:Basic -u:root -p:'Pine#Tar*9' -skipcncheck -skipcacheck -encoding:utf-8
# "$result | Should Not BeNullOrEmpty" not works here, it is a Pester bug, so just use Length verificaiton now
$result.Length # Should BeGreaterThan 1



#Work
winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://OMITST-UBUN16-01.SCX.COM:5986 -auth:Basic -u:root -p:'Pine#Tar*9' -skipcncheck -skipcacheck -encoding:utf-8
Describe " PowerShell Remoting basic functional tests" -Tag @("CI") {
        BeforeAll {
            $LinuxHostName = $env:LINUXHOSTNAME
            $LinuxUserName = $env:LINUXUSERNAME
            $linuxPasswordString = $env:LINUXPASSWORDSTRING
            $WindowsHostName = $env:WINDOWSHOSTNAME
            $WindowsUserName = $env:WINDOWSUSERNAME
            $windowsPasswordString = $env:WINDOWSPASSWORDSTRING
            $badUserName = "badUserName"
            $badPassword = "badPassword"
            $Port = 5986
        }

        #PowerShell from Windows/Linux/MacOS to Linux with basic authentication over https should work
        It "957006:<Basic><HTTPS><Windows/Linux/Mac-Linux>:Powershell with valid credentials should work." {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            $password=$linuxPasswordString
            $PWord = convertto-securestring $password -asplaintext -force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User,$PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption
            $result = Invoke-Command -Session $mySession {Get-Host}
            $result.PSComputerName|Should Not BeNullOrEmpty
            # Linux/MacOS to Linux: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
            if($IsWindows)
            {
                Get-PSSession|Disconnect-PSSession
            }
            Get-PSSession|Remove-PSSession
        }

        # WSMan from Windows to Linux with basic authentication with winrm over https should work
        It "957007:<Basic><HTTPS><Windows-Linux>: Winrm with valid credentials should work"  -Skip:($IsLinux -Or $IsOSX){
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            $result = winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:Basic -u:$User -p:$linuxPasswordString -skipcncheck -skipcacheck -encoding:utf-8
            # "$result | Should Not BeNullOrEmpty" not works here, it is a Pester bug, so just use Length verificaiton now
            $result.Length|Should BeGreaterThan 1
        }

        #WSMan from Linux/MacOS to Linux with basic authentication with omicli over https should work
        It "957008:<Basic><HTTPS><Linux/Mac-Linux>: Omicli with valid credentials should work" {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            if($IsLinux -Or $IsOSX)
            {
                $result = /opt/omi/bin/omicli id -u $User -p $linuxPasswordString --auth Basic --hostname $hostname --port $Port --encryption https
                $result|Should Not BeNullOrEmpty
            }
        }

        #PowerShell from Windows to Linux with basic authentication with bad username over https should throw exception
        It "957009:<Basic><HTTPS><Windows-Linux>: Powershell with invalid username should throw exception." -Skip:($IsLinux -Or $IsOSX) {
            $hostname = $LinuxHostName
            $User = $badUserName
            $password=$linuxPasswordString
            $PWord = Convertto-SecureString $password -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User,$PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            try
            {
                $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption -ErrorAction Stop
                Invoke-Command -Session $mySession {Get-Host}
            }
            catch
            {
                $_.FullyQualifiedErrorId | Should be "AccessDenied,PSSessionOpenFailed"
            }
        }

        #PowerShell from Linux/MacOS to Linux with basic authentication with bad password over https should throw exception
        It "957010:<Basic><HTTPS><Linux/Mac-Linux>: Powershell with invalid password should throw exception." -Skip:$IsWindows {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            $PWord = Convertto-SecureString $badPassword -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            try
            {
                $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption -ErrorAction Stop
                Invoke-Command -Session $mySession {Get-Host}
            }
            catch
            {
                # it maybe a error message issue on Linux/MacOS, just keep it now.
                $_.FullyQualifiedErrorId | Should be "2,PSSessionOpenFailed"
            }
        }

        # WSMan from Windows to Linux with basic authentication with winrm with bad username over https should throw exception
        It "957011:<Basic><HTTPS><Windows-Linux>: Winrm with invalid username should throw exception" -Skip:($IsLinux -Or $IsOSX) {
            $hostname = $LinuxHostName
            $User = $badUserName

            try
            {
                 winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:Basic -u:$User -p:$linuxPasswordString -skipcncheck -skipcacheck -encoding:utf-8
            }
            catch
            {
                 $_.FullyQualifiedErrorId | Should be "NativeCommandError"
            }
        }

        #WSMan from Linux/MacOS to Linux with basic authentication with omicli with bad username over https should throw exception
        It "957012:<Basic><HTTPS><Linux/Mac-Linux>: Omicli with invalid username should throw exception." -Skip:$IsWindows {
            $hostname = $LinuxHostName
            $User = $badUserName
            try
            {
            $result=/opt/omi/bin/omicli id -u $User -p $linuxPasswordString --auth Basic --hostname $hostname --port $Port --encryption https
            }
            catch
            {
            $result | Should Match 'error'
            }
        }

        #WSMan from Windows to Linux with basic authentication with winrm with bad password over https should throw exception
        It "957013:<Basic><HTTPS><Windows-Linux>: Winrm with invalid password should throw exception." -Skip:($IsLinux -Or $IsOSX) {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            
            try
            {
                winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:Basic -u:$User -p:$badPassword -skipcncheck -skipcacheck -encoding:utf-8
            }
            catch
            {
                $_.FullyQualifiedErrorId | Should be "NativeCommandError"
            }
        }

        #WSMan from Linux/MacOS to Linux with basic authentication with omicli with bad password over https should throw exception
        It "957014:<Basic><HTTPS><Linux/Mac-Linux>: Omicli with invalid password should throw exception." -Skip:$IsWindows {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            try
            {
            $result = /opt/omi/bin/omicli id -u $User -p $badPassword --auth Basic --hostname $hostname --port $Port --encryption https
            }
            catch
            {
            $result | Should be'error'
            }
        }

        #Skip Windows to Windows because of not support.
        #PowerShell from Linux/MacOS to Windows with basic authentication over http should work
        It "957015:<Basic><HTTP><Linux/Mac-Windows>: Powershell with valid credentials should work." -Skip:($IsWindows) {
            $hostname = $WindowsHostName
            $User = $WindowsUserName
            $PWord = Convertto-SecureString $windowsPasswordString -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -SessionOption $sessionOption
            $result = Invoke-Command -Session $mySession {Get-Host}
            $result|Should Not BeNullOrEmpty
            # Linux/MacOS to Windows: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
            if($IsWindows)
            {
                Get-PSSession|Disconnect-PSSession
            }
            Get-PSSession|Remove-PSSession
        }

        #WSMan from Linux/MacOS to Windows with basic authentication by omicli over http should work
        It "957016:<Basic><HTTP><Linux/Mac-Windows>: Omicli with valid credentials should work." -Skip:($IsWindows) {
            $hostname = $WindowsHostName
            $User = $WindowsUserName
            $HTTPPort=5985
            $result = /opt/omi/bin/omicli ei root/cimv2 Win32_SystemOperatingSystem -u $User -p $windowsPasswordString --auth Basic --hostname $hostname --port $HTTPPort --encryption none
            $result|Should Not BeNullOrEmpty
        }

        #Powershell from Liunx/MacOS to Windows with basic authentication over https over http with bad username should throw exception
         It "957017:<Basic><HTTP><Windows/Linux/Mac-Windows>: Powershell with invalid username should throw exception." -Skip:($IsWindows) {
            $hostname = $WindowsHostName
            $User = $badUserName
            $PWord = Convertto-SecureString $windowsPasswordString -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            try
            {
                $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption -ErrorAction Stop
                Invoke-Command -Session $mySession {Get-Host}
            }
            catch
            {
                $_.FullyQualifiedErrorId | Should be "1,PSSessionOpenFailed"
            }
            }

        #Powershell from Liunx/MacOS to Windows with basic authentication over https over http with bad password should throw exception
         It "957018:<Basic><HTTP><Windows/Linux/Mac-Windows>: Powershell with invalid password should throw exception." -Skip:($IsWindows) {
            $hostname = $WindowsHostName
            $User = $WindowsUserName
            $password=$badPassword
            $PWord = Convertto-SecureString $password -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            try
            {
                $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption -ErrorAction Stop
                Invoke-Command -Session $mySession {Get-Host}
            }
            catch
            {
                $_.FullyQualifiedErrorId | Should be "1,PSSessionOpenFailed"
            }
            }

        #WSMan from Linux/MacOS to Windows with basic authentication over https with bad username by omicli over http should throw exception
        It "957019:<Basic><HTTP><Linux/Mac-Windows>: Omicli with invalid username should throw exception." -Skip:($IsWindows) {
            $hostname = $LinuxHostName
            $User = $badUserName
            try{
            $result = /opt/omi/bin/omicli id -u $User -p $linuxPasswordString --auth Basic --hostname $hostname --port $Port --encryption https
            }
            catch
            {
            $result | Should Match 'error'
            }
        }

        
        #WSMan from Linux/MacOS to Windows with basic authentication over https with bad password by omicli over http should throw exception
        It "957020:<Basic><HTTP><Linux/Mac-Windows>: Omicli with invalid password should throw exception." -Skip:($IsWindows) {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            try
            {
            $result = /opt/omi/bin/omicli id -u $User -p $badPassword --auth Basic --hostname $hostname --port $Port --encryption https
            }
            catch
            {
            $result | Should Match 'error'
            }
        }

        #PowerShell from Windows/Linux/MacOS to Linux with negotiate authentication over https should work
        It "957021:<Negotiate><HTTPS><Windows/Linux/Mac-Linux>: Powershell with valid credentials should work." {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            $password=$linuxPasswordString
            $PWord = convertto-securestring $password -asplaintext -force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User",$PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption
            $result = Invoke-Command -Session $mySession {Get-Host}
            $result.PSComputerName|Should Not BeNullOrEmpty
            # Linux/MacOS to Linux: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
            if($IsWindows)
            {
                Get-PSSession|Disconnect-PSSession
            }
            Get-PSSession|Remove-PSSession
        }

        #WSMan from Windows to Linux with negotiate authentication with winrm over https should work
        It "957022:<Negotiate><HTTPS><Windows-Linux>: Winrm with valid credentials should work" -SKip:($IsLinux -Or $IsOSX) {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            $result = winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:negotiate -u:"$hostname\$User" -p:$linuxPasswordString -skipcncheck -skipcacheck -encoding:utf-8
            # "$result | Should Not BeNullOrEmpty" not works here, it is a Pester bug, so just use Length verificaiton now
            $result.Length|Should BeGreaterThan 1
        }

        #WSMan from Linux/MacOS to Linux with negotiate authentication with omicli over https should work
        It "957023:<Negotiate><HTTPS><Linux/Mac-Linux>: Omicli with valid credentials should work" -SKip:($IsWindows) {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            if($IsLinux -Or $IsOSX)
            {
                $result = /opt/omi/bin/omicli id -u "$hostname\$User" -p $linuxPasswordString --auth NegoWithCreds --hostname $hostname --port $Port --encryption https
                $result|Should Not BeNullOrEmpty
            }
        }

        #PowerShell from Linux/MacOS to Linux with negotiate authentication with bad username over https should throw exception
        It "957024:<Negotiate><HTTPS><Linux-Linux>: Powershell with invalid username should throw exception." -Skip:$IsWindows {
            $hostname = $LinuxHostName
            $User = $badUserName
            $PWord = Convertto-SecureString $badPassword -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            try
            {
                $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption -ErrorAction Stop
                Invoke-Command -Session $mySession {Get-Host}
            }
            catch
            {
                # it maybe a error message issue on Linux/MacOS, just keep it now.
                $_.FullyQualifiedErrorId | Should be "2,PSSessionOpenFailed"
            }
        }

        #PowerShell from Windows to Linux with negotiate authentication with bad password over https should throw exception
        It "957025:<Negotiate><HTTPS><Windows-Linux>: Powershell with invalid password should throw exception." -Skip:($IsLinux -Or $IsOSX) {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            $password=$badPassword
            $PWord = Convertto-SecureString $password -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User",$PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            try
            {
                $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption -ErrorAction Stop
                Invoke-Command -Session $mySession {Get-Host}
            }
            catch
            {
                $_.FullyQualifiedErrorId | Should be "AccessDenied,PSSessionOpenFailed"
            }
        }

        #WSMan from Windows to Linux with negotiate authentication with winrm with bad username over https should throw exception.
        It "957026:<Negotiate><HTTPS><Windows-Linux>: Winrm with invalid username should throw exception." -Skip:($IsLinux -Or $IsOSX) {
            $hostname = $LinuxHostName
            $User = $badUserName

            try
            {
                 winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:negotiate -u:$User -p:$linuxPasswordString -skipcncheck -skipcacheck -encoding:utf-8
            }
            catch
            {
                 $_.FullyQualifiedErrorId | Should be "NativeCommandError"
            }
        }
   
         #WSMan from Linux/MacOS to Linux with negotiate authentication with omicli with bad username over https should throw exception
        It "957027:<Negotiate><HTTPS><Linux/Mac-Linux>: Omicli with invalid username should throw exception" -Skip:$IsWindows {
            $hostname = $LinuxHostName
            $User = $badUserName
            try{
            $result = /opt/omi/bin/omicli id -u $User -p $linuxPasswordString --auth NegoWithCreds --hostname $hostname --port $Port --encryption https
            }
            catch
            {
            $result | Should Match 'error'
            }
        }
          
          #WSMan from Windows to Linux with negotiate authentication with winrm with bad password over https should throw exception      
          It "957028:<Negotiate><HTTPS><Windows-Linux>: Winrm with invalid password should throw exception." -Skip:($IsLinux -Or $IsOSX) {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            
            try
            {
                winrm enumerate http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/OMI_Identify?__cimnamespace=root/omi -r:https://${hostname}:$Port -auth:negotiate -u:$User -p:$badPassword -skipcncheck -skipcacheck -encoding:utf-8
            }
            catch
            {
                $_.FullyQualifiedErrorId | Should be "NativeCommandError"
            }
        }
        
         #WSMan from Linux/MacOS to Linux with negotiate authentication with omicli with bad password over https should throw exception
        It "957029:<Negotiate><HTTPS><Linux/Mac-Linux>: Omicli with invalid password should throw exception." -Skip:$IsWindows {
            $hostname = $LinuxHostName
            $User = $LinuxUserName
            try
            {
            $result = /opt/omi/bin/omicli id -u $User -p $badPassword --auth NegoWithCreds  --hostname $hostname --port $Port --encryption https
            }
            catch
            {
            $result | Should Match 'error'
            }
        }

        #Skip Windows to Windows because of not support.
        #PowerShell from Linux/MacOS to Windows with negotiate authentication over http should work
        It "957030:<Negotiate><HTTP><Linux/Mac-Windows>: Powershell with valid credentials should work." -Skip:($IsWindows) {
            $hostname = $WindowsHostName
            $User = $WindowsUserName
            $PWord = Convertto-SecureString $windowsPasswordString -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$hostname\$User", $PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -SessionOption $sessionOption
            $result = Invoke-Command -Session $mySession {Get-Host}
            $result|Should Not BeNullOrEmpty
            # Linux/MacOS to Windows: Disconnect-PSSession not works, error:"To support disconnecting, the remote computer must be running Windows PowerShell 3.0 or a later version of Windows PowerShell.", just skip it.
            if($IsWindows)
            {
                Get-PSSession|Disconnect-PSSession
            }
            Get-PSSession|Remove-PSSession
        }

         #WSMan from Linux/MacOS to Windows with negotiate authentication with omicli over http should work
         It "957031:<Negotiate><HTTP><Linux/Mac-Windows>: Omicli with valid credentials should work." -Skip:($IsWindows) {
            $hostname = $WindowsHostName
            $User = $WindowsUserName
            $HTTPPort=5985
            $result = /opt/omi/bin/omicli ei root/cimv2 Win32_SystemOperatingSystem -u $User -p $windowsPasswordString --auth NegoWithCreds --hostname $hostname --port $HTTPPort --encryption none
            $result|Should Not BeNullOrEmpty
        }

        #Powershell from Liunx/MacOS to Windows with negotiate authentication over https over http with bad username should throw exception
         It "957032:<Negotiate><HTTP><Windows/Linux/Mac-Windows>: Powershell with invalid username should throw exception." -Skip:($IsWindows) {
            $hostname = $WindowsHostName
            $User = $badUserName
            $PWord = Convertto-SecureString $windowsPasswordString -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            try
            {
                $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication negotiate -UseSSL -SessionOption $sessionOption -ErrorAction Stop
                Invoke-Command -Session $mySession {Get-Host}
            }
            catch
            {
                $_.FullyQualifiedErrorId | Should be "1,PSSessionOpenFailed"
            }
         }

         #Powershell from Liunx/MacOS to Windows with negotiate authentication over https over http with bad password should throw exception
         It "957033:<Negotiate><HTTP><Windows/Linux/Mac-Windows>: Powershell with invalid password should throw exception." -Skip:($IsWindows) {
            $hostname = $WindowsHostName
            $User = $WindowsUserName
            $PWord = Convertto-SecureString $badPassword -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
            $sessionOption = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck
            try
            {
                $mySession = New-PSSession -ComputerName $hostname -Credential $cred -Authentication Basic -UseSSL -SessionOption $sessionOption -ErrorAction Stop
                Invoke-Command -Session $mySession {Get-Host}
            }
            catch
            {
                $_.FullyQualifiedErrorId | Should be "1,PSSessionOpenFailed"
            }
            }

        #WSMan from Linux/MacOS to Windows with negotiate authentication over https with bad username by omicli over http should throw exception
        It "957034:<Negotiate><HTTP><Linux/Mac-Windows>: Omicli with invalid username should throw exception." -Skip:($IsWindows) {
            $hostname = $LinuxHostName
            $User = $badUserName
            try
            {
            $result = /opt/omi/bin/omicli id -u $User -p $linuxPasswordString --auth Basic --hostname $hostname --port $Port --encryption https
            }
            catch
            {
            $result | Should Match 'error'
            }
        }

        #WSMan from Linux/MacOS to Windows with negotiate authentication over https with bad password by omicli over http should throw exception
        It "957035:<Negotiate><HTTP><Linux/Mac-Windows>: Omicli with invalid password should throw exception." -Skip:($IsWindows) {
            $hostname = $LinuxHostName
            $User = $badUserName
            try
            {
            $result = /opt/omi/bin/omicli id -u $User -p $badPassword --auth Basic --hostname $hostname --port $Port --encryption https
            }
            catch
            {
            $result | Should Match 'error'
            }
        }
    }
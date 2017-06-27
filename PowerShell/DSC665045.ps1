 Configuration MyTestConfig{
Import-DscResource -Module nx;
Node "mix-deb5x64-02"
{
nxPackage Package
{
Name = "nano"
Ensure = "absent"
PackageManager = "apt"
}
#DependdeResourceType 
#DependedResourceName
{
#DependedProperties
}
}
};
MyTestConfig -outputpath:C:\Temp\mix-deb5x64-01_MOF


 [void] (C:\Temp\config_mix-deb5x64-01.ps1);    ########### Generate Mof ###########
      [void] (winrm set winrm/config/client '@{TrustedHosts="*"}');
      $securePass = ConvertTo-SecureString -string "Pine#Tar*9" -AsPlainText -Force;
      $cred= New-Object System.Management.Automation.PSCredential "root", $SecurePass;
      $opt = New-CimSessionOption -UseSsl:$true -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true;
      $demo1=New-CimSession -Credential:$cred -ComputerName:mix-deb5x64-01 -Port:5986 -Authentication:basic -SessionOption:$opt;
      Start-DscConfiguration -CimSession:$demo1 -Path:"C:\Temp\mix-deb5x64-01_MOF" -Wait -force;
      Get-DscConfiguration -CimSession $demo1;
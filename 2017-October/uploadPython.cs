using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Cahce
{
    class Program
    {
        static void Main(string[] args)
        {
        }

        /* Upload share.tar to /opt/omi/ and Uppack */
        private void UploadPythonPackages(string packageFolfer, string username, string pwd, string from)
        {
            
            SshHelper rootssh = new SshHelper(from, username, pwd);
            //Upload Provider to linux and run the script
            DirectoryInfo dir = new DirectoryInfo(Path.Combine(packageFolfer));
            try
            {
                string osname = GetOSName(rootssh);
                
                foreach (FileInfo f in dir.GetFiles("*"))
                {
                    string fileName = f.Name;
                    string fullFileName = f.FullName;
                    switch (fileName)
                    {

                        case "share.tar":
                            ctx.Alw("Uploading and uppack the share.tar");
                            rootssh.Upload(fullFileName, "/root/share.tar");
                            rootssh.VerifyExecuteCommand("chmod +x /root/share.tar; tar xvf /root/share.tar -C /opt/omi/");
                            ctx.Alw(string.Format("Result:{0}", rootssh.Result));
                            break;
                        case "ProviderAndMofFiles.tar":
                            ctx.Alw("Uploading and uppack the ProviderAndMofFiles.tar");
                            rootssh.Upload(fullFileName, "/root/ProviderAndMofFiles.tar");
                            rootssh.VerifyExecuteCommand("chmod +x /root/ProviderAndMofFiles.tar; tar xvf /root/ProviderAndMofFiles.tar -C /opt/omi/lib");
                            ctx.Alw(string.Format("Result:{0}", rootssh.Result));
                            break;
                            //case "samples.tar":
                            //    ctx.Alw("Uploading and registering the libfilesys.so");
                            //    rootssh.Upload(fullFileName, "/root/libfilesys.so");
                            //    rootssh.VerifyExecuteCommand("chmod +x /root/libfilesys.so; /opt/omi/bin/omireg --hosting '@requestor@' -n root/cimv2 /root/libfilesys.so");
                            //    ctx.Alw(string.Format("Result:{0}", rootssh.Result));
                            //    break;

                    }
                }    
            }
            catch (Exception ex)
            {

                ctx.Alw(string.Format("Failed to upload package files from Windows to remote Linux, error:{0}", ex.Message));

            }
        }

        /* Setup the ENV */
        public string UploadPackages(string packagesFolder, string userName, string password)
        {
            ctx.Alw(string.Format("Setup Linux OMI Environment"));
            string osPackageFilesPath = "BuildPlatform_PackageFiles.txt";
            string PackagesFolder = GetValueByKey("PackagesFolder");
            string buildNumber = GetValueByKey("BuildNumber");
            string providerFolder = GetValueByKey("ProviderFolder");
            //string macMachine = GetValueByKey("macMachine");
            string errorMessage = string.Empty;

            
            string summaryResult = "<?xml version=\"1.0\" encoding=\"utf-16\"?><rootResult xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><LinuxResults>";
            foreach (string from in Linuxs)
            {
                SshHelper rootssh = new SshHelper(from, userName, password);

                //Upload GetOS.sh to linux and run the script
                string osname = GetOSName(rootssh);

                //Uninstall OMI
                ctx.Alw(string.Format("Uninstall OMI on {0}, osname:{1}", from, osname));
                UninstallOMIPackage(rootssh, osname);

                ctx.Alw(string.Format("Setup Negotiate and Kerberos authentication on Linux Server after install OMI on {0}, osname:{1}", from, osname));

                //Build Platform
                string buildPlatform = GetBuildPlatformByOSName(osname);
                ctx.Alw(string.Format("GetBuildPlatformByOSName OMI on {0}, osname:{1},buildPlatform:{2}", from, osname, buildPlatform));
                if (!File.Exists(osPackageFilesPath))
                {
                    this.Abort(ctx, "Need file:" + osPackageFilesPath);
                }

                rootssh.ExecuteCommand("openssl version");
                string opensslversion = rootssh.Result;

                //Upload Packages "share.tar"
                string linuxFile = UploadPythonPackage(rootssh, PackagesFolder, buildPlatform, osname, opensslversion, buildNumber);








                //Install OMI
                InstallOMIPackage(rootssh, osname, linuxFile);

                //Register OMI provider
                ctx.Alw(string.Format("Setup Linux OMI Providers"));
                string provierPath = Path.Combine(providerFolder, buildPlatform);
                UploadRegisterProvider(provierPath, buildPlatform, opensslversion, userName, password, from);
                summaryResult += "<LinuxResult><name>" + from + "</name><result><![CDATA[" + rootssh.Result + "]]></result></LinuxResult>";

                
                rootssh.VerifyExecuteCommand("/opt/omi/bin/service_control restart");
            }

            summaryResult += "</LinuxResults></rootResult>";

            if (!string.IsNullOrEmpty(errorMessage))
            {
                this.Fail(ctx, errorMessage);
            }

            return summaryResult;
        }

    }
}

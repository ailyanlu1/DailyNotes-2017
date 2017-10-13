using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using sshcomLib;

namespace OMIAutomation
{
    public class SshHelper
    {
        private string Host = null;
        private int Port = 22;
        private string Username = null;
        private string Password = null;
        private sshcomLib.scxsshClass ssh;
        public string Result = string.Empty;

        public SshHelper(string host, string username, string password)
        {
            Host = host;
            Username = username;
            Password = password;
            ssh = new scxsshClass();
            ssh.ConnectWithPassword(Host, Port, Username, Password);
        }

        private void EnsureInit()
        {
            if (Host == null || Username == null || Password == null)
            {
                throw new Exception("Host, Username, Password should not be null!");
            }
        }

        public int ExecuteCommand(string cmd)
        {
            EnsureInit();
            string result=string.Empty;
            int ret = (int)ssh.ExecuteCommand2(cmd, out result);
            Result = result.Trim();
            return ret;
        }

        public int VerifyExecuteCommand(string cmd)
        {
            EnsureInit();
            string result = string.Empty;
            int ret = (int)ssh.ExecuteCommand2(cmd, out result);
            Result = result.Trim();
            if (ret != 0)
            {
                throw new Exception(string.Format("Execute command {0} did not execute successfully, result {1}", cmd, Result));
            }
            return ret;
        }

        public int ExecuteShellCommand(string cmd)
        {
            EnsureInit();
            string result = string.Empty;
            int ret = (int)ssh.ShellCommand2(cmd, out result);
            Result = result.Trim();
            return ret;
        }

        /// <summary>
        /// Interface method to copy files from a Posix host
        /// </summary>
        /// <param name="sourcePath">Path for source file(s)</param>
        /// <param name="destPath">Destination path</param>
        public void CopyFrom(string sourcePath, string destPath)
        {
            if (String.IsNullOrEmpty(sourcePath))
            {
                throw new ArgumentException("sourcePath is null or empty");
            }

            if (String.IsNullOrEmpty(destPath))
            {
                throw new ArgumentException("destPath is null or empty");
            }

            this.ssh.SFTPCopyToLocal(sourcePath, destPath);
        }

        /// <summary>
        /// Interface method to copy files to a Posix host
        /// </summary>
        /// <param name="sourcePath">Path for source file(s)</param>
        /// <param name="destPath">Destination path</param>
        public void CopyTo(string sourcePath, string destPath)
        {
            if (String.IsNullOrEmpty(sourcePath))
            {
                throw new ArgumentException("sourcePath is null or empty");
            }

            if (String.IsNullOrEmpty(destPath))
            {
                throw new ArgumentException("destPath is null or empty");
            }

            // Returns uint, but throws exception on error (like source file not found)
            this.ssh.SFTPCopyToRemote(sourcePath, destPath);
        }

        /// <summary>
        /// Upload
        /// </summary>
        /// <param name="winPath">winPath</param>
        /// <param name="linuxPath">linuxPath</param>
        /// <returns></returns>
        public int Upload(string winPath, string linuxPath)
        {
            EnsureInit();
            int ret = (int)ssh.SFTPCopyToRemote(winPath, linuxPath);
            return ret;
        }

        /// <summary>
        /// Download
        /// </summary>
        /// <param name="linuxPath">linuxPath</param>
        /// <param name="winPath">winPath</param>
        /// <returns></returns>
        public int Download(string linuxPath, string winPath)
        {
            EnsureInit();
            int ret = (int)ssh.SFTPCopyToLocal(linuxPath, winPath);
            return ret;
        }

        ~SshHelper()
        {
            this.Dispose();
        }

        protected void Dispose()
        {
            if (this.ssh != null)
            {
                this.ssh.Shutdown();
            }
        }
    }
}

## sshcom

Manual:

* 1. Copy the dll files to local like C:\sshcom
* 2. Run cmd as admin and cd to C:\sshcom     cd C:\sshcom
* 3. Run “regsvr32 sshcom.dll” in the cmd
* 4. In VS, Solution ->References->sshcomLib , Properties "Embed Interop Types" set "False".
* 5. Rebuild the solution

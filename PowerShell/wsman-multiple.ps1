
$provider="SCX_FileSystem"
$clients="mix64-sles10-01","mix64-sles10-02","mix86-sles10-01","mix86-sles10-02","mix64-sles11-01","mix64-sles11-02","mix86-sles11-01","mix86-sles11-02"
$status1=""

foreach($item in $clients)
{
    
    winrm e http://schemas.microsoft.com/wbem/wscim/1/cim-schema/2/$provider`?__cimnamespace=root/scx -username:root -r:https://$item.scx.com:1270 -auth:basic -encoding:utf-8 -password:Pine#Tar*9 -skipCAcheck -skipCNcheck -skipRevocationCheck
    if($?)
    {
        $status1=$status1 + "`n" + $item + " -------- Pass"
    }
    else{
        $status1=$status1 + "`n" + $item + " -------- Failed"
    }

}

"`n" + "`n" + "******************Wsman Running Result*****************" 
 $status1


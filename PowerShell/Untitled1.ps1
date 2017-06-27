[System.Environment] | Get-Member Static

[System.Environment]::OSVersion

[System.Environment]::HasShutdownStarted

[System.Math] | Get-Member -Static -MemberType Methods

[System.Math]::Sqrt(9)

[System.Math]::Pow(2,3)

[System.Math]::Floor(3.3)

[System.Math]::Floor(-3.3)

[System.Math]::Ceiling(3.3)

[System.Math]::Ceiling(-3.3)

[System.Math]::Max(2,7)

[System.Math]::Min(2,7)

[System.Math]::Truncate(3.33)

[System.Math]::Truncate(-9.45)

Get-Process | Get-Member | Out-Host -Paging

Get-Item -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion | Select-Object -ExpandProperty Property

Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion
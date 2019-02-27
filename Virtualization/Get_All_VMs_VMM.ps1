Enter-PSSession vmmserver
Import-Module -Name VirtualMachineManager
Get-VM | Where-Object -FilterScript {$_.OperatingSystem -notmatch "windows"} | sort OperatingSystem | ft name,OperatingSystem,CreationTime -AutoSize
Enter-PSSession vmmserver
Import-Module -Name VirtualMachineManager
$servers = type c:\temp\servers.txt


$servers | foreach {Stop-SCVirtualMachine $_ }

Get-SCVirtualMachine -Name server
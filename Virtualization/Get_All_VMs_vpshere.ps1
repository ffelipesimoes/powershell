#Enter your vCenter Host below
$vcenter = "vcenterserver"
#Load the VMware Powershell snapin if the script is being executed in PowerShell
Add-PSSnapin VMware.VimAutomation.Core -ErrorAction 'SilentlyContinue'
 
#Connect to the vCenter server defined above. Ignore certificate errors
Write-Host "Connecting to vCenter"
Connect-VIServer $vcenter -wa 0
Write-Host "Connected"
Write-Host ""

$VM = get-view –viewtype VirtualMachine # –filter @{“Name”=”server05”}
$VM.Config | Where-Object -FilterScript {$_.guestfullname -notmatch "microsoft"} | sort GuestFullName | ft name, GuestFullName -AutoSize 

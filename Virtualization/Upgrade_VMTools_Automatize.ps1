#Enter your vCenter Host below
$vcenter = "your_vcenter_server"
################################
 
#Load the VMware Powershell Module
Add-PSsnapin VMware.VimAutomation.Core
 
#Connect to the vCenter server defined above. Ignore certificate errors
Connect-VIServer $vcenter -wa 0
 
#Get the folder name from the user. Update all VM's if blank
$folder = Read-Host "Which folder would you like to update? (Leave blank to update all VM's)"
 
#Check if the user entered a folder. If a folder was provided return only the VM's for that folder
If($folder)
{
Write-Host "Updating VM's in $folder"
#Get all VM's for a specified folder and return only their names
$virtualmachines = Get-Folder $folder | Get-VM | select -expandproperty Name
}
 
#Else if the user left the folder blank, get all VM's
Else
{
Write-Host "Updating all VM's"
#Get all VM's in the vCenter and return only their names
$virtualmachines = Get-VM | select -expandproperty Name
}
 
#Perform the following for each VM returned
ForEach ($vm in $virtualmachines)
{
Write-Host "Updating VMware Tools on $VM"
#Update VMware tools without rebooting the VM
Update-Tools $vm -NoReboot
}
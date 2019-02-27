Add-PSSnapin VMware.VimAutomation.Core -ErrorAction 'SilentlyContinue'
Connect-VIServer vcenterserver
get-vm | Get-Snapshot | ft vm,name,powerstate -AutoSize



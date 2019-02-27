Add-PSSnapin VMware.VimAutomation.Core -ErrorAction 'SilentlyContinue'

Connect-VIServer vcenterserver

$VMs = Get-VM | Where-Object {$_.ExtensionData.ResourceConfig.MemoryAllocation.Reservation -ne "0" -or $_.ExtensionData.ResourceConfig.CpuAllocation.Reservation -ne "0"}
ForEach ($VM in $VMs)
    { 
    "" | Select @{N="Name";E={$VM.Name}},
    @{N="CPU Reservation";E={$VM.ExtensionData.ResourceConfig.CpuAllocation.Reservation}},
    @{N="Memory Reservation";E={$VM.ExtensionData.ResourceConfig.MemoryAllocation.Reservation }} 
    } 
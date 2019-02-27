####################################################################
# Summary of Virtual Machines
####################################################################
$VMs = @(Get-VM)

Write-Host "`nVIRTUAL MACHINES" -ForegroundColor Yellow

Write-Host "Total VMs    :", $VMs.Count
Write-Host "Hosted VMs   :", @($VMs | where {$_.Status -ne "Stored"}).Count
Write-Host "Stored VMs   :", @($VMs | where {$_.Status -eq "Stored"}).Count
Write-Host "Running VMs  :", @($VMs | where {$_.Status -eq "Running"}).Count
Write-Host "Self-Service VMs           :", @($VMs | where {$_.SelfServicePolicy -ne $null}).Count
Write-Host "VMs without VMAdditions    :", @($VMs | where {$_.HasVMAdditions -eq $false}).Count


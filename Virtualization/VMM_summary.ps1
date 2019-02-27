####################################################################
# Summary of Virtual Machine Host Groups
####################################################################
$VMHostGroups = @(Get-VMHostGroup)
$VMs = @(Get-VM)

Write-Host "`nVIRTUAL MACHINE HOST GROUPS" -ForegroundColor Yellow

foreach ($VMHostGroup in $VMHostGroups)
{
    $VMHostCount = $VMHostGroup.Hosts.Count
    $VMCount = @($VMs | where {$VMHostGroup.Hosts -contains $_.VMHost}).Count
    $RunningVMCount = @($VMs | where {$VMHostGroup.Hosts -contains $_.VMHost} | where {$_.Status -eq "Running"}).Count
    $SelfServiceVMCount = @($VMs | where {$VMHostGroup.Hosts -contains $_.VMHost} | where {$_.SelfServicePolicy -ne $null}).Count

    Write-Host "Host Group               :", $VMHostGroup.Name
    Write-Host "Number of Hosts          :", $VMHostCount
    if ($VMHostCount -ne 0)
    {
    Write-Host "Number of VMS            :", $VMCount
    Write-Host "Running VMs              :", $RunningVMCount
    Write-Host "Self-Service VMs         :", $SelfServiceVMCount
    Write-Host "VMs per Host             :", ($VMCount / $VMHostCount)
    Write-Host "Running VMs per Host     :", ($RunningVMCount / $VMHostCount)
    Write-Host "Self-Serice VMs per Host :", ($SelfServiceVMCount / $VMHostCount)
    }
    Write-Host
}
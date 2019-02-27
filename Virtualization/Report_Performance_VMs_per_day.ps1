#VARIABLES
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$CSV = "c:\Average_CPU_Usage_Peak_Hours.csv"
#Parameters
$vcenter = "vcenterserver" #Name of your vcenter server
$ClusterName = "Cluster name" #CPU usage and CPU ready values will be collected for all VMs in this cluster.
$DaysBack = 1 #Number of days back to collect performance counters.
$PeakTimeStart = 7 #hour of the day in 24 hour format 
$PeakTimeEnd = 19 #hour of the day in 24 hour format
$rdy_interval = 7200 #interval of rdy time values aggregation/averaging in seconds. This value should be changed according to your vcenter statistics settings.

function Connect-Vcenter {
    param(
        $vcenter
    )
    #Load snap-in
    if (-not (Get-PSSnapin -Name VMware.VimAutomation.Core)) {
        Add-PSSnapin VMware.VimAutomation.Core
    }
    #Connect to vCenter
    if ($global:DefaultVIServers.Count -lt 1) {
        Connect-VIServer $vCenter
    }
}

function Get-VMCPUAverage {
    param (
        $VM
    )
    $Start = (get-date).AddDays(-$DaysBack)
    $Finish = get-date
     
    $stats = get-vm $VM | get-stat -MaxSamples "1000" -Start $Start -Finish $Finish -Stat "cpu.usage.average" | `
    ? { ($_.TimeStamp).Hour -gt $PeakTimeStart -and ($_.TimeStamp).Hour -lt $PeakTimeEnd }
    $aggr_stats = $stats | Measure-Object -Property Value -Average
    $avg = $aggr_stats.Average
    return $avg
}

function Get-VMCpuRDY {
    param (
        $VM
    )
    $Start = (get-date).AddDays(-$DaysBack)
    $Finish = get-date
     
    $stats = get-vm $VM | Get-Stat -MaxSamples "1000" -Start $Start -Finish $Finish -Stat Cpu.Ready.Summation | `
    ? { ($_.TimeStamp).Hour -gt $PeakTimeStart -and ($_.TimeStamp).Hour -lt $PeakTimeEnd -and $_.Instance -eq ""}   
    $aggr_stats = $stats | Measure-Object -Property Value -Average 
    $rdy = [Math]::Round(((($aggr_stats.Average)/1000)/$rdy_interval) * 100,1)
    return $rdy
}


#SCRIPT MAIN
clear
#Load the VMWare module and connect to vCenter
Connect-Vcenter -vcenter $vcenter
$AvgCPUValues = @() #Create array to hold the CPU usage and CPU ready values
Get-Cluster $ClusterName | Get-VM | ? {$_.PowerState -eq "PoweredOn"} | % { #loop through all powered on VMs in the cluster
    $AvgCPUValue = "" | Select "VM","CpuAvg","CpuRdy" #create a custom object with these properties.
    $AvgCPUValue.VM = $_.Name
    $AvgCPUValue.CpuAvg = "{0:N2}" -f $(Get-VMCPUAverage -VM $_) #Get VM CPU usage and round to two decimals
    $AvgCPUValue.CpuRdy = Get-VMCpuRDY -VM $_
    $AvgCPUValues += $AvgCPUValue
}
$AvgCPUValues | Export-Csv $CSV -NoTypeInformation -Force
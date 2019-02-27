clear-host
$allhosts = @()
$hosts = Get-VMHost -Name fohvp01.tj.ce.gov.br
$start = (Get-Date).AddDays(-30)
$stat = 'cpu.usage.average','mem.usage.average','net.usage.average'#,'net.bytesRx.average','net.bytesTx.average','datastore.totalReadLatency.average','datastore.totalWriteLatency.average'
 
Get-Stat -Entity $hosts -Stat $stat -Start $start |
Group-Object -Property {$_.Entity.Name} | %{
  $cpuStat = $_.Group | where{$_.MetricId -eq 'cpu.usage.average'} |
    Measure-Object -Property value -Average -Maximum -Minimum
  $memStat = $_.Group | where{$_.MetricId -eq 'mem.usage.average'} |
    Measure-Object -Property value -Average -Maximum -Minimum
      
  [pscustomobject]@{
    HostName = $_.Group[0].Entity.Name
    CPUAvg = $cpuStat.Average
    CPUMin = $cpuStat.Minimum
    CPUMax = $cpuStat.Maximum
    MemAvg = $cpuStat.Average
    MemMin = $cpuStat.Minimum
    MemMax = $cpuStat.Maximum
    NetUsage = $_.Group | where{$_.MetricId -eq 'net.usage.average'} | Measure-Object -Property Value -Average | Select -ExpandProperty Average
    #NetTr = $_.Group | where{$_.MetricId -eq 'net.bytesTx.average'} | Measure-Object -Property Value -Average | Select -ExpandProperty Average
    #NetRx = $_.Group | where{$_.MetricId -eq 'net.bytesRx.average'} | Measure-Object -Property Value -Average | Select -ExpandProperty Average
    #DSReadLatency = $_.Group | where{$_.MetricId -eq 'datastore.totalReadLatency.average'} | Measure-Object -Property Value -Average | Select -ExpandProperty Average
    #DSWriteLatency = $_.Group | where{$_.MetricId -eq 'datastore.totalWriteLatency.average'} | Measure-Object -Property Value -Average | Select -ExpandProperty Average
  }
}
Invoke-Command -ComputerName vvmmserver -ScriptBlock {
Import-Module -Name virtualmachinemanager
clear
$checktime = (get-date).adddays(-60)
get-vm | Where-Object -FilterScript {$_.CreationTime -ge $checktime}  | sort creationtime| ft name, CreationTime -AutoSize
write-host -ForegroundColor Yellow "Máquinas criadas de $Checktime até hoje:" (get-vm | Where-Object -FilterScript {$_.CreationTime -ge $checktime}).count  
}
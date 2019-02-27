$time = Read-Host "Informe a quantidade de dias a ser verificado: "
$SO = "Windows XP"
$checktime = (get-date).adddays(-$time)
$currenttime = Get-Date
$XP = (Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonDate | Where-Object -FilterScript {$_.LastlogonDate -ge $checktime} | 
Where-Object -FilterScript {$_.OperatingSystem -match $SO } | Select-Object name,LastLogonDate, OperatingSystem).count

$SO = "Windows 7"
$7 = (Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonDate | Where-Object -FilterScript {$_.LastlogonDate -ge $checktime} |
Where-Object -FilterScript {$_.OperatingSystem -match $SO } | Select-Object name,LastLogonDate, OperatingSystem).count

$SO = "Windows 8"
$8 = (Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonDate | Where-Object -FilterScript {$_.LastlogonDate -ge $checktime} |
Where-Object -FilterScript {$_.OperatingSystem -match $SO } | Select-Object name,LastLogonDate, OperatingSystem).count


Write-Host "Quantidade de estações por Sistema Operacional"
Write-Output "Windows XP: $xp "  
Write-Output "Windows  7: $7 "  
Write-Output "Windows  8: $8 " 
Write-Output " "
Write-Output "Os números acima são de estações que conectaram-se ao domínio nos ultimos $time dias! Ou seja, de $checktime até $currenttime"

# opção adicional sobre Service pack 1
#$SO = "Windows 7"
#($serverlist1).count = Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonDate, OperatingSystemServicePack | Where-Object -FilterScript {$_.LastlogonDate -ge $checktime} |
#Where-Object -FilterScript {$_.OperatingSystem -match $SO } | Where-Object -FilterScript {$_.OperatingSystemServicePack -notcontains "Service Pack 1" } |
#Select-Object name,LastLogonDate, OperatingSystem, OperatingSystemServicePack).count
#Get-ADComputer TTJDEINF0153710 -Properties *
#OperatingSystemServicePack 
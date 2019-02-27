# Criando sessão remota no servidor
Enter-PSSession -ComputerName "wsusserver"

# Connection with WSUS Server
$Computername = 'wsusserver'
$UseSSL = $False
$Port = 8530
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Computername,$UseSSL,$Port)

# para remover a primeira liha em branco de um comando use: ( comando | ft -HideTableHeaders  | Out-String).Trim()
# Listar os 50 updates para Windows XP
#$timeXP = "10/06/2003 00:00:00"
$timeXP = Get-Content E:\WsusDados\Repository_PowerShell\DateLastApplyUpdateXP.txt
$timeXP = get-date $timeXP
$updatesXP = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows XP" -and $_.Creationdate -ge $timeXP } | 
Select-Object -First 50  KnowledgebaseArticles,CreationDate
($updatesXP | Select-Object -Last 1 creationdate | ft -HideTableHeaders  | Out-String).Trim() |Out-File E:\WsusDados\Repository_PowerShell\DateLastApplyUpdateXP.txt
 

# Listar os 50 updates para Windows 7
#$time7 = "10/03/2009 00:00:00"
$time7 = Get-Content E:\WsusDados\Repository_PowerShell\DateLastApplyUpdate7.txt
$time7 = get-date $time7
$updates7 = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows 7" -and $_.Creationdate -ge $time7 } |
Select-Object -First 50  KnowledgebaseArticles,CreationDate
($updates7 | Select-Object -Last 1 creationdate | ft -HideTableHeaders  | Out-String).Trim() |Out-File E:\WsusDados\Repository_PowerShell\DateLastApplyUpdate7.txt
 

# Listar os 50 updates para Windows 8.1
#$time81 = "08/10/2013 00:00:00"
$time81 = Get-Content E:\WsusDados\Repository_PowerShell\DateLastApplyUpdate81.txt
$time81 = get-date $time81
$updates81 = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows 8.1"  -and $_.Creationdate -ge $time81 } |
Select-Object -First 50  KnowledgebaseArticles, creationdate
($updates81 | Select-Object -Last 1 creationdate | ft -HideTableHeaders  | Out-String).Trim() |Out-File E:\WsusDados\Repository_PowerShell\DateLastApplyUpdate81.txt


# Exportar os dados acima para o arquivo
($UpdatesXP + $Updates7 + $Updates81 | ft -HideTableHeaders KnowledgebaseArticles | Out-String).Trim()| Out-File E:\WsusDados\Repository_PowerShell\UpdatesToInstall.txt

# Substituindo caracteres
$file = Get-Content E:\WsusDados\Repository_PowerShell\UpdatesToInstall.txt
$file = $file.Replace('{', 'KB')
$file = $file.Replace('}', '')
$file = $file.Replace('  ', '')
$file | Out-File E:\WsusDados\Repository_PowerShell\UpdatesToInstall.txt


foreach ($f in $file) {
$update = $wsus.SearchUpdates($f) # Nome do KB ou atualização
$group = $wsus.GetComputerTargetGroups() | where {$_.Name -eq ‘WDS_Client’} # nome do grupo que será liberado a atualização
$update[0].ApproveForOptionalInstall($Group) # aprovando atualização para o grupo informado
}

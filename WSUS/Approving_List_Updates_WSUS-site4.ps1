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
#$lastupdatetime__XP = "10/06/2003 00:00:00"
#Lendo a ultima data setada
$Lastupdatetime_XP = Get-Content E:\WsusDados\Repository_PowerShell\COMARCA\DateLastApplyUpdate_XP.txt
$Lastupdatetime_XP = get-date $Lastupdatetime_XP
#Fazendo consulta dos Updates
$updates_XP = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows XP" -and $_.Creationdate -ge $Lastupdatetime_XP } | 
Select-Object -First 50  KnowledgebaseArticles,CreationDate,ProductTitles
#Exportando dados para texto
($updates_XP | Select-Object -Last 1 creationdate | ft -HideTableHeaders  | Out-String).Trim() |Out-File E:\WsusDados\Repository_PowerShell\COMARCA\DateLastApplyUpdate_XP.txt

# Listar os 50 updates para Windows 7
#$lastupdatetime_7 = "10/03/2009 00:00:00"
#Lendo a ultima data setada
$lastupdatetime_7 = Get-Content E:\WsusDados\Repository_PowerShell\COMARCA\DateLastApplyUpdate_7.txt
$lastupdatetime_7 = get-date $lastupdatetime_7
#Fazendo consulta dos Updates
$updates_7 = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows 7" -and $_.Creationdate -ge $lastupdatetime_7 } |
Select-Object -First 50  KnowledgebaseArticles,CreationDate,ProductTitles
#Exportando dados para texto
($updates_7 | Select-Object -Last 1 creationdate | ft -HideTableHeaders  | Out-String).Trim() |Out-File E:\WsusDados\Repository_PowerShell\COMARCA\DateLastApplyUpdate_7.txt
 

# Listar os 50 updates para Windows 8.1
#$lastupdatetime_81 = "08/10/2013 00:00:00"
#Lendo a ultima data setada
$lastupdatetime_81 = Get-Content E:\WsusDados\Repository_PowerShell\COMARCA\DateLastApplyUpdate_81.txt
$lastupdatetime_81 = get-date $lastupdatetime_81
#Fazendo consulta dos Updates
$updates_81 = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows 8.1"  -and $_.Creationdate -ge $lastupdatetime_81 } |
Select-Object -First 50  KnowledgebaseArticles, creationdate,ProductTitles
#Exportando dados para texto
($updates_81 | Select-Object -Last 1 creationdate | ft -HideTableHeaders  | Out-String).Trim() |Out-File E:\WsusDados\Repository_PowerShell\COMARCA\DateLastApplyUpdate_81.txt

# Exportar os dados acima para o arquivo
($updates_XP + $Updates_7 + $Updates_81 | ft -HideTableHeaders KnowledgebaseArticles | Out-String).Trim()| Out-File E:\WsusDados\Repository_PowerShell\COMARCA\UpdatesToInstall_COMARCA.txt

$fileName = "UpdateList-" + (Get-Date -Format ddMMyyyy) + ".txt"
$location = "E:\WsusDados\Repository_PowerShell\COMARCA\Log_KB_Installed"
($updates_XP + $Updates_7 + $Updates_81  | Out-String).Trim() | Out-file -append -FilePath (Join-Path $location $fileName)

# Substituindo caracteres
$file_COMARCA = Get-Content E:\WsusDados\Repository_PowerShell\COMARCA\UpdatesToInstall_COMARCA.txt
$file_COMARCA = $file_COMARCA.Replace('{', 'KB')
$file_COMARCA = $file_COMARCA.Replace('}', '')
$file_COMARCA = $file_COMARCA.Replace('  ', '')
$file_COMARCA | Out-File E:\WsusDados\Repository_PowerShell\COMARCA\UpdatesToInstall_COMARCA.txt

#Aplicando Updates aos grupos no WSUS
foreach ($f_COMARCA in $file_COMARCA) {
$update = $wsus.SearchUpdates($f_COMARCA) # Nome do KB ou atualização
$group = $wsus.GetComputerTargetGroups() | where {$_.Name -eq ‘Homologação’} # nome do grupo que será liberado a atualização
$update[0].ApproveForOptionalInstall($Group) # aprovando atualização para o grupo informado
}

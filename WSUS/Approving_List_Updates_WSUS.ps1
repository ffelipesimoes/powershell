# Criando sessão remota no servidor
Enter-PSSession -ComputerName "wsusserver"

# Connection with WSUS Server
$Computername = 'wsusserver'
$UseSSL = $False
$Port = 8530
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Computername,$UseSSL,$Port)


# Listar os 50 updates para Windows XP
$timeXP = "10/06/2004 00:00:00"
$updatesXP = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows XP" -and $_.Creationdate -ge $time } |
Select-Object -First 50  KnowledgebaseArticles

# Listar os 50 updates para Windows 7
$time7 = "10/03/2009 00:00:00"
$updates7 = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows 7" -and $_.Creationdate -ge $time7 } |
Select-Object -First 50  KnowledgebaseArticles

# Listar os 50 updates para Windows 8.1
$time81 = "08/10/2013 00:00:00"
$updates81 = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows 8.1"  -and $_.Creationdate -ge $time81 } |
Select-Object -First 50  KnowledgebaseArticles
# Exportar os dados acima para o arquivo
$UpdatesXP + $Updates7 + $Updates81 | ft -HideTableHeaders | Out-File c:\updates.txt

# Substituindo caracteres
$file = Get-Content C:\updates.txt
$file = $file.Replace('{', 'KB')
$file = $file.Replace('}', '')
$file = $file.Replace('  ', '')
$file | Out-File C:\updates.txt


foreach ($f in $file) {
$update = $wsus.SearchUpdates($f) # Nome do KB ou atualização
$group = $wsus.GetComputerTargetGroups() | where {$_.Name -eq ‘WDS_Client’} # nome do grupo que será liberado a atualização
$update[0].ApproveForOptionalInstall($Group) # aprovando atualização para o grupo informado
}

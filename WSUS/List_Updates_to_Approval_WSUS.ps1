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
Select-Object -First 50  KnowledgebaseArticles,CreationDate, Description 
$displayUpdateXP = $updatesXP | fl KnowledgebaseArticles, Description

# Listar os 50 updates para Windows 7
$time7 = "10/03/2009 00:00:00"
$updates7 = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows 7" -and $_.Creationdate -ge $time7 } |
Select-Object -First 50  KnowledgebaseArticles,CreationDate, Description 
$displayUpdate7 = $updates7 | fl KnowledgebaseArticles, Description 

# Listar os 50 updates para Windows 8.1
$time81 = "08/10/2013 00:00:00"
$updates81 = $Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} | Where-Object -FilterScript {$_.ProductTitles -match "Windows 8.1"  -and $_.Creationdate -ge $time81 } |
Select-Object -First 50  KnowledgebaseArticles,CreationDate, Description 
$displayUpdate81 = $updates81 | fl KnowledgebaseArticles, Description

#  Caso deseje exportar lista para um arquivo
#$displayUpdateXP + $displayUpdate7 + $displayUpdate81 | Out-File c:\updates.txt

Clear-Host
Write-Host "-------------------------"
Write-Host "Updates para Windows XP -"
Write-Host "-------------------------" 
$displayUpdateXP
Write-Host "-------------------------"
Write-Host "Updates para Windows 7  -"
Write-Host "-------------------------" 
$displayUpdate7
Write-Host "-------------------------"
Write-Host "Updates para Windows 8.1 -"
Write-Host "-------------------------" 
$displayUpdate81



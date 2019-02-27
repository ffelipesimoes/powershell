# Criando sessão remota no servidor
Enter-PSSession -ComputerName "wsusserver" 

# Connection with WSUS Server
$Computername = 'wsusserver'
$UseSSL = $False
$Port = 8530

[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Computername,$UseSSL,$Port)

$UpdateXPApproved = ($Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} |Where-Object -FilterScript {$_.ProductTitles -match "Windows XP" -and $_.Isapproved -match "true"} | ft -AutoSize KnowledgebaseArticles,CreationDate,ProductTitles,IsApproved).count
$UpdateXPDeclined = ($Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} |Where-Object -FilterScript {$_.ProductTitles -match "Windows XP" -and $_.Isapproved -match "false"} | ft -AutoSize KnowledgebaseArticles,CreationDate,ProductTitles,IsApproved).count
$Update7Approved = ($Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} |Where-Object -FilterScript {$_.ProductTitles -match "Windows 7" -and $_.Isapproved -match "true"} | ft -AutoSize KnowledgebaseArticles,CreationDate,ProductTitles,IsApproved).count
$Update7Declined = ($Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} |Where-Object -FilterScript {$_.ProductTitles -match "Windows 7" -and $_.Isapproved -match "false"} | ft -AutoSize KnowledgebaseArticles,CreationDate,ProductTitles,IsApproved).count
$Update81Approved = ($Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} |Where-Object -FilterScript {$_.ProductTitles -match "Windows 8.1" -and $_.Isapproved -match "true"} | ft -AutoSize KnowledgebaseArticles,CreationDate,ProductTitles,IsApproved).count
$Update81Declined = ($Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} |Where-Object -FilterScript {$_.ProductTitles -match "Windows 8.1" -and $_.Isapproved -match "false"} | ft -AutoSize KnowledgebaseArticles,CreationDate,ProductTitles,IsApproved).count


Write-Host "Atualmente existem: "
Write-Host "------------"
Write-Host "Windows XP -"
Write-Host "------------ "
Write-Host "$UpdateXPApproved Atualizações Aprovadas"
Write-Host "$UpdateXPDeclined Atualizações Declinadas"
Write-Host "------------ "
Write-Host "Windows 7  -"
Write-Host "------------ "
Write-Host "$Update7Approved Atualizações Aprovadas"
Write-Host "$Update7Declined Atualizações Declinadas"
Write-Host "------------ "
Write-Host "Windows 8.1  -"
Write-Host "------------ "
Write-Host "$Update81Approved Atualizações Aprovadas"
Write-Host "$Update81Declined Atualizações Declinadas"







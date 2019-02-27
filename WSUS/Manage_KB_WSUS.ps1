

# Criando sessão remota no servidor
Enter-PSSession -ComputerName "wsusserver" -Credential user@@domain

# armazenar KB na variavel
$kb = Get-Content c:\kb.txt

# conexão com o WSUS
$Computername = 'wsusserver'
$UseSSL = $False
$Port = 8530

[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Computername,$UseSSL,$Port)


foreach ($k in $kb) {
$wsus.SearchUpdates("KB975053") | Select-Object  title, description | fl  }



#comando para trazer os updates  com as descrições
$Wsus.GetUpdates() | Where-Object -FilterScript {$_.producttitles -match "Windows 7"} |  fl   KnowledgebaseArticles,ProductTitles,Description | Select-Object -First 50



# Criando sessão remota no servidor
Enter-PSSession -ComputerName "wsusserver" -Credential 400062u@tj.ce.gov.br

# Connection with WSUS Server
$Computername = 'wsusserver'
$UseSSL = $False
$Port = 8530

[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Computername,$UseSSL,$Port)

$list = Get-Content E:\WsusDados\Repository_PowerShell\PILOTO\List_Machine_PILOTO.txt

#Adding a client to a target group
foreach ($machine in $list) {
$Client = $wsus.SearchComputerTargets("$machine")
$group = $wsus.GetComputerTargetGroups() | Where {$_.Name –eq “PILOTO”}
$group.AddComputerTarget($client[0])
}
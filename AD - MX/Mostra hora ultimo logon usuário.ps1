$domain = "contoso.com" 
 

import-module activedirectory 
"O domínio atual é " + $domain 
$samaccountname = Read-Host 'Qual a conta do Usuário?' 
"Processando as informações ..." 
$myForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest() 
$domaincontrollers = $myforest.Sites | % { $_.Servers } | Select Name 
$RealUserLastLogon = $null 
$LastusedDC = $null 
$domainsuffix = "*."+$domain 
foreach ($DomainController in $DomainControllers)  
{ 
    if ($DomainController.Name -like $domainsuffix ) 
    { 
        $UserLastlogon = Get-ADUser -Identity $samaccountname -Properties LastLogon -Server $DomainController.Name 
        if ($RealUserLastLogon -le [DateTime]::FromFileTime($UserLastlogon.LastLogon)) 
        { 
            $RealUserLastLogon = [DateTime]::FromFileTime($UserLastlogon.LastLogon) 
            $LastusedDC =  $DomainController.Name 
        } 
    } 
} 
"O ultimo logon ocorreu às " + $RealUserLastLogon + "" 
"Autenticado no Controlador de domínio: " + $LastusedDC + "" 
$mesage = "............." 
#$exit = Read-Host $mesage
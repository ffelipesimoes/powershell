New-ADGroup -Name groupname -GroupCategory Security -GroupScope Global -DisplayName groupname -Path "OU=Grupos,OU=TJCE,DC=tj,DC=ce,DC=gov,DC=br"  -Description "Acesso R/W pasta \\tjce-sai-01\CIJ"

Add-ADGroupMember -Identity groupname -Members "96","4080","304","96170","8242","1900"

Write-Host "Group" -ForegroundColor Green
Get-ADGroupMember -identity  Group | ft name, samaccountname
Get-ADGroup -filter  * -properties GroupCategory | ft name,groupcategory
Get-ADGroup Group
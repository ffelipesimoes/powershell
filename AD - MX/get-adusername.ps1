#$user = Get-Content C:\temp\list.txt
#$user | foreach {(Get-ADUser $_ |ft name -HideTableHeaders  | Out-String).Trim()}
#Get-Content C:\temp\list.txt | foreach {(Get-ADUser $_ |ft name -HideTableHeaders  | Out-String).Trim()}

Param (
[Parameter(Mandatory=$true)][string]$username
)
$User = Get-ADUser $username 
foreach ($a in $user) {
    $Nameuser = $a.Name
    Write-Output $Nameuser
}
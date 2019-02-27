Get-ADGroupMember "groupname" | Select-Object name | Export-Csv C:\TEMP\groupname.txt
$a = Get-Content C:\TEMP\TJADMWORK.txt
$a = $a.Replace('#TYPE Selected.Microsoft.ActiveDirectory.Management.ADPrincipal', '')
$a = $a.Replace('name', '')
$a = $a.Replace('"', '')
$a > C:\TEMP\groupname.txt


# Lê o arquivo e informa onde será a saida
$servers= get-content 'C:\TEMP\groupname.txt'
$output = 'c:\temp\ListAdmin.csv' 
$results = @()

foreach($server in $servers)
{
$admins = @()
$group =[ADSI]"WinNT://$server/Administradores" 
$members = @($group.psbase.Invoke("Members"))
$members | foreach {
 $obj = new-object psobject -Property @{
 Server = $Server
 Admin = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
 }
 $admins += $obj
 } 
$results += $admins
}
$results | Export-csv $Output -NoTypeInformation


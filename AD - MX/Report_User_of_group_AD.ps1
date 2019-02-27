$user = type C:\temp\users.txt
$user | foreach { (Get-ADUser $_ -Properties * | ft  name, samaccountname, department, enabled,description, lastlogondate -AutoSize -HideTableHeaders  | Out-String).Trim()}

$list | where {$_.lastlogondate -le (get-date).adddays(-30)}

$list | ConvertTo-Csv -NoTypeInformation

name, samaccountname, department, enabled,description, lastlogondate

set-ADUser -Identity filipe  -Enabled $false 

foreach ($U in $user) {
set-ADUser -Identity $U  -Enabled $false 
}

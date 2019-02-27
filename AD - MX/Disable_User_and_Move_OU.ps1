$UserList = Get-Content "C:\Users\my user\Downloads\Lista_user.txt"
$OU = 'CN=xxxxxxxx,OU=xxxxxxxx,OU=xxxxxxxx,DC=domain'
foreach ($User in $UserList) {
Get-ADUser -Identity $User  | Move-ADObject -TargetPath $OU
}
foreach ($U in $UserList) {
set-ADUser -Identity $U  -Enabled $true 
}

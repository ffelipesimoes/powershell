
#Here we import the tools to work with AD.
#
Import-Module ActiveDirectory
#
#$checktime = (get-date).adddays(-1000)
#(Get-ADUser -SearchBase "OU=xxxxxxx,domain" -Properties LastLogonDate -Filter {LastlogonDate -le $checktime} |
#Select-Object name,LastLogonDate,samaccountName).count

#This is where group memberships are removed.
#
$checktime = (get-date).adddays(-100)
$users = (Get-ADUser -SearchBase "OU=xxxxxx,domain" -Properties LastLogonDate -Filter {LastlogonDate -ge $checktime} |
Select-Object samaccountName)

$username = "xxxx"

foreach ($u in $users) {
Get-ADPrincipalGroupMembership -Identity $Username | ft name } | % {Remove-ADPrincipalGroupMembership -Identity $Username -MemberOf $_ -Confirm:$False}
#
#This is where we disabled the account
#
Disable-ADAccount -Identity $Username
#
#This is where we specify where the user will be moved in AD.
#
Get-ADUser $Username | Move-ADObject -TargetPath OU=xxxxxx,domain
#
#
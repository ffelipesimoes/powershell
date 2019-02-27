# Criar um grupos no AD 

New-ADGroup -Name ITManageComputers -GroupCategory Security -GroupScope Global -DisplayName ITManageComputers
New-ADGroup -Name Gerentes -GroupCategory Security -GroupScope Global -DisplayName Gerentes

New-ADGroup -Name groupname -GroupCategory Security -GroupScope Global -DisplayName groupname -Path "OU=Grupos,OU=orgganized U,dc=contoso,dc=com" -Description " xxxxxx"
# Criar uma OU

New-ADOrganizationalUnit -Name "SP"
New-ADOrganizationalUnit -Name "Gerentes de TI"
New-ADOrganizationalUnit -Name "Projetos"

#Criar usuários já em uma OU

New-ADUser "BillGates" -Path "OU=Gerentes de TI,dc=contoso,dc=com" -Department "Gerencia"
New-ADUser "SteveBallmer" -Path "OU=Gerentes de TI,dc=contoso,dc=com" -Department "Gerencia"
New-ADUser "SteveWoz" -Path "OU=Projetos,dc=contoso,dc=com" -Department "Projetos"

#Gerenciando grupos no AD
Get-ADGroupMember  groupname

Add-ADGroupMember -Identity groupname -Members gpo

Remove-ADGroupMember -Identity groupname -Members gpo

$text = Get-Content C:\TEMP\list.txt
foreach ($t in $text) {
Remove-ADGroupMember -Identity groupname -Members $t
}



#Definir a senha para um usuário 

Set-ADAccountPassword BillGates

# Adicionar usuários a grupos

Get-ADUser -Filter * -SearchBase "ou=gerentes de ti, dc=contoso,dc=com" | Add-ADPrincipalGroupMembership -MemberOf Gerentes

#Listar todos os usuários de uma OU 

Get-ADUser -Filter * -SearchBase "ou=Fornecedores,dc=contoso,dc=com"

#Fazer com que todos os usuários de uma OU alterem sua senha no próximo logon

Get-ADUser -Filter * -SearchBase "ou=Projetos,dc=contoso,dc=com"| Set-ADUser -ChangePasswordAtLogon $true

#Listar usuários de um determinado departamento

Get-ADUser –Filter 'department -eq "department"' -Properties Department | Format-Table name,DistinguishedName,Department

# lista usuários com senha sem expirar
Get-ADUser -Filter * -Properties PasswordNeverExpires| ft name, samaccountname,PasswordNeverExpires, enabled -AutoSize

#Listar o último logon do usuário

Get-ADUser user –properties lastlogondate

#Listar todos os usuários e o último logon de cada um

Get-ADUser -filter *  | fl name, lastlogondate

# Ver todos os usuários desabilitados

Get-ADUser -filter * | where { $_.enabled -eq $False}

#habilitar todos os usuários que estão desabilitados 

Get-ADUser -filter * | where { $_.enabled -eq $False} | Enable-ADAccount

# Ver usuários com opção "Password never Expires"
Get-ADUser -Filter * -Properties PasswordNeverExpires | where { $_.PasswordNeverExpires -eq $true } | select Name | sort 

#How to check Powershell Version?
$host.Version.Major
OR
$psversiontable
OR
:::::::::Microsoft Powershell:::::::
Get-Host | Select-Object Version

#How to find Users from an OU using ADSI?
$test =
[adsi] "LDAP://localhost:389/ou=test,dc=contoso,dc=COM"
$searcher = [adsisearcher] $test
$searcher.Filter = '(objectClass=User)'
$searcher.FindAll() 
#All AD Users All attrs.
Get-ADUser -F * -PR * | Export-Csv Usersreports.csv -NoTypeInformation

#How to find Locked out accounts?
search-adaccount -u -l | ft name,lastlogondate -auto

#To unlock an account
Unlock-ADAccount -Identity BBISWAJIT

#Finding the Lockout Events
#Windows 2008
Get-EventLog -log Security | ? EventID -EQ 4740
#Windows 2003
Get-EventLog -log Security | ? EventID -EQ 644

6#Find some specific attributes for an OU users
get-aduser -f * -Searchbase "ou=powershell,dc=contoso,dc=com" -pr SamAccountName,PasswordExpired,whenChanged,UserPrincipalName

7#Find some specific attributes using input file
get-content c:\users.txt | get-aduser -pr SamAccountName,PasswordExpired,whenChanged,UserPrincipalName

8#How to reset the passwords for some specific users
get-content c:\users.txt | get-aduser | Set-ADAccountPassword -NewPassword (ConvertTo-SecureString -AsPlainText monster@me123 -Force)

9#How to update the manager field for bulk users?
get-content c:\users.txt | get-aduser | Set-ADUser -Manager "Biswajit"

10#How to update "ProfilePath","homeDrive" & "HomeDirectory" based on a input file?
Get-Content users.txt | ForEach-Object {
  Set-ADUser -Identity $_ -ProfilePath "\\WIN-85IOGS94Q68\profile\$_" -homedrive "Y:" -homedirectory "\\WIN-85IOGS94Q68\netshare\$_"
}

11#Find Users exist in AD or Not?
$users = get-content c:\users.txt
foreach ($user in $users) {
$User = Get-ADUser -Filter {(samaccountname -eq $user)}
If ($user -eq $Null) {"User does not exist in AD ($user)" }
Else {"User found in AD ($user)"}
}

12#Find users are enabled and have E-Mail and Homedirectory and PasswordExpired -eq false)}
PS C:\> Get-ADUser -Filter {(enabled -eq $true) -and (EmailAddress -like "*") -and (Homedirectory -like "*") -and (PasswordExpired -eq $false)}

13#Also finding the Groupmembership.
PS C:\>  Get-ADUser -Filter {(enabled -eq $true) -and (EmailAddress -like "*") -and (Homedirectory -like "*") -and
(PasswordExpired -eq $false) -and (MemberOf -eq "CN=rock2,OU=win7,DC=Jaihanuman,DC=net")}

14#ProtectedFromAccidentalDeletion for all the users
Get-ADObject -filter {(ObjectClass -eq "user")} | Set-ADObject -ProtectedFromAccidentalDeletion:$true

15# How to find the users property using ADSI.
$users1=[ADSI]"LDAP://cn=copy,cn=users,dc=contoso,dc=com"
$users1 | select *

16#search-adaccount (Accounts Disable,inactive)
search-adaccount (Accounts Disable,inactive)
search-adaccount -u -accountd -searchb "ou=test,dc=contoso,dc=com"
search-adaccount -u -accountd
search-adaccount -u -accounti -t "90"
search-adaccount -u -accounti -da "28 feb 2013"

Search-ADAccount -AccountDisabled -UsersOnly | Select-Object name, samaccountname,lastlogondate,enabled | Out-GridView



::::::::Quest Powershell:::::::::
1#Find the Disabled members from multiple GROUPS. 
Get-Content c:\groups.txt | ForEach-Object {
  Get-QADGroupMember $_ -Disabled
} 
2#Find the E-MAILs of Users form an particular OU 
get-QADuser -SearchRoot 'contoso.com/test' | select samaccountname,mail

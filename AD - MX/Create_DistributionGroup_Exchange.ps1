$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mailboxserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
#consultar grupo 
#Get-DistributionGroup -Identity "groupname" | fl alias,PrimarySmtpAddress

#Create DistributionGroup
$group = 'groupname'
$samaccountname = $group
$alias = 'aliasfromgroup'
new-DistributionGroup -Name $group -OrganizationalUnit 'Domain/UO/' -SamAccountName $samaccountname  -Alias $alias

#lista de usuarios dentro de um TXT
$users_groups = Get-Content C:\temp\user.txt

#adicionando usuários ao grupo
foreach ($user in $users_groups) {
Add-DistributionGroupMember -Identity $group -Member $user }

#consultando usuários adicionados
Get-DistributionGroupMember -Identity $group | ft

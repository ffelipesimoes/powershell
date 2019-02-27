#Criar sessão na console Exchange
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://Maiboxserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
$groupname = ''
$user = type C:\temp\users.txt
$user | ForEach {Add-DistributionGroupMember -Identity $groupname -Member $_}
Get-DistributionGroupMember -Identity $groupname
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mailboxserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
#comando completo - Send As
#Add-ADPermission -Identity 'CN=xxxxxxxx,OU=xxxxxxxx,OU=xxxxxxxx,DC=domain' -User 'domain\user' -ExtendedRights 'Send-as'
#comando completo - Full Acess
#Add-MailboxPermission -Identity 'CN=xxxxxxxx,OU=xxxxxxxx,OU=xxxxxxxx,DC=domain' -User 'domain\user' -AccessRights 'FullAccess'

Get-Mailbox *xxx* | ft -AutoSize

$mailbox = "xxxxxx"
$UserPrincipalName = $mailbox + "@domain"
$name = "xxxxxx"
New-Mailbox -Name $name -Alias $mailbox -OrganizationalUnit "domain/OU Mailbox/" -UserPrincipalName $UserPrincipalName -SamAccountName $mailbox -FirstName $mailbox -Initials "" -LastName "" -Database "xxxxxx" #-Password "System.Security.SecureString" -ResetPasswordOnNextLogon $false  


Add-ADPermission $mailbox -User "my user" -Extendedrights "Send As"
Add-MailboxPermission $mailbox -User "my user" -AccessRights "FullAccess" 



$user = Get-Content C:\temp\list.txt
$user | foreach {
    Add-ADPermission $name -User $_ -Extendedrights "Send As"
    Add-MailboxPermission $name -User $_ -AccessRights "FullAccess" 
}



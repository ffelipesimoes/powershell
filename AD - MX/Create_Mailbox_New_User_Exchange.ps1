$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mailboxserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
New-Mailbox -Name 'xxxxxxxxx' -Alias 'xxxxxxxxx' -OrganizationalUnit 'domain/UO' -UserPrincipalName 'xxxxxxxxx@domain' -SamAccountName 'xxxxxxxxx' -FirstName 'xxxxxxxxx' -Initials '' -LastName '' -Password 'System.Security.SecureString' -ResetPasswordOnNextLogon $false -Database 'xxxxxxxxx'


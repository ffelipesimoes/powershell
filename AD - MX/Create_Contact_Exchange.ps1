$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mailboxserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session

New-MailContact -ExternalEmailAddress 'SMTP:user@contactDomain' -Name 'fulano de tal' -Alias 'fulano' -FirstName 'fulano' -Initials '' -LastName 'de tal' -OrganizationalUnit 'Domain/UO/Contats'

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://exchangeserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
Get-MailboxDatabase -Status | select ServerName,Name,DatabaseSize
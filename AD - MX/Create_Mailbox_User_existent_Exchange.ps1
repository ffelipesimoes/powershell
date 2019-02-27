$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://tjemp01/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
Enable-Mailbox -Identity 'domain/UO/gpo1' -Alias 'xxxxx' -Database 'xxxxxxxxxx'
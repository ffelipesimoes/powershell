$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mailboxserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session

Write-Host "List Users" -ForegroundColor White -BackgroundColor Red
Get-DistributionGroupMember "group" | ft  PrimarySmtpAddress -AutoSize 


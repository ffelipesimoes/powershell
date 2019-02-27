$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mailboxserver/Powershell/ -Authentication Kerberos -Credential $usercredential
Import-PSSession $session

$user = "xxxxxxxxx"
Get-Mailbox $user| fl SamAccountName,Name,IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,UseDatabaseQuotaDefaults
Set-Mailbox -Identity $user -IssueWarningQuota 2200mb -ProhibitSendReceiveQuota 2300mb -UseDatabaseQuotaDefaults $false
Get-Mailbox $user| fl SamAccountName,Name,IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,UseDatabaseQuotaDefaults


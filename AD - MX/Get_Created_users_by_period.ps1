Get-ADUser -Filter * -Properties whenCreated | Where-Object {$_.whenCreated -ge ((Get-Date).AddDays(-30)).Date} | ft name, samaccountname, whencreated


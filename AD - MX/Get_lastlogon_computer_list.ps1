$serverlist1 = Get-Content C:\TEMP\x.txt
foreach ($server in $serverlist1) {
Get-ADComputer -Identity $server -Properties lastlogondate | ft name, lastlogondate
}
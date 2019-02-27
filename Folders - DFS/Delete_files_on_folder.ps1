Get-ChildItem C:\temp2 | ft name -HideTableHeaders > c:\temp\log.txt
$logfile = Get-Content c:\temp\log.txt 
foreach ($log in $logfile) {Remove-Item C:\temp2\*$log -Recurse }
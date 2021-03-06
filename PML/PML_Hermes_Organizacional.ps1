get-service -Name JBAS50SVC | Stop-Service

$date = Get-Date -Format d
$date = $date.Replace('/', '')
$file1 = "C:\jboss-4.2.3.GA\server\default\deploy\application.ear"
$backup_file = "C:\jboss-4.2.3.GA\server\default\Backup\"
$newname = "application-" + $date + ".ear"
$newpath = $backup_file + $newname
# Renomeia arquivo inserindo data no final
Move-Item $file1 $newpath
$file2 = "C:\jboss-4.2.3.GA\server\default\deploy\application2.ear"
$newname2 = "application2-" + $date + ".ear"
$newpath2 = $backup_file + $newname2
Move-Item $file2 $newpath2
Remove-Item C:\jboss-4.2.3.GA\server\default\tmp -Recurse -Force
Remove-Item C:\jboss-4.2.3.GA\server\default\work -Recurse -Force
Remove-Item C:\jboss-4.2.3.GA\server\default\data -Recurse -Force

get-service -Name JBAS50SVC | Start-Service
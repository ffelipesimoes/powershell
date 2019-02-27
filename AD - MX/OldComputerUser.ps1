#Lista todos os usuários que fizeram logon nos ultimos 180 dias.
$checktime = (get-date).adddays(-180)
get-aduser  -Properties LastLogonDate -filter {LastlogonDate -ge $checktime} |
Select-Object name,LastLogonDate,samaccountName |Export-Csv C:\TEMP\user.xls

#Lista todos as estações que se conectaram ao AD nos ultimos 60 dias.
$checktimeComputer = (get-date).adddays(-60)
Get-ADComputer -Properties LastLogonDate -filter {LastlogonDate -ge $checktimecomputer} |
Select-Object name,LastLogonDate  |Export-Csv C:\TEMP\micro.xls
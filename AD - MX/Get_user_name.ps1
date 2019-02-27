$name = Get-Content C:\TEMP\User-Name.txt
foreach ($n in $name) {
Get-ADUser  $n  | fl name }
$count = Get-Content C:\TEMP\mat.txt
foreach ($c in $count) {
Set-ADAccountPassword -Identity $c -NewPassword (ConvertTo-SecureString -AsPlainText "123456" -Force)
}
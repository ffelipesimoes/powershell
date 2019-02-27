Get-Service -Name "DNS" | Stop-Service -PassThru 
$date = Get-Date -Format d
$date = $date.Replace('/', '')
$path = "C:\Windows\System32\dns\backup\domain-"
$newpath = $path + $date + ".sign"
copy-Item C:\Windows\System32\dns\domain.sign $newpath
$newpath2 = $path + $date + ".cert"
copy-Item C:\Windows\System32\dns\domain.cert $newpath2
move-Item -Force C:\Windows\System32\dns\domain.sign C:\Windows\System32\dns\domain.cert
C:\Windows\System32\dns\Sign_dns_auto\Assinatura_DNS.bat
C:\Windows\System32\dns\Sign_dns_auto\StartDNS_192.168.10.33.bat
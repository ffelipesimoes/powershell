
$comp = Read-Host "Informe o caminho do compartilhamento "
$acl = Get-Acl -Path $comp
Write-Host "Segue as permissões da pasta $comp" -ForegroundColor Green -BackgroundColor Black -NoNewline
$acl.Access | ft FileSystemRights, AccessControlType, IdentityReference -AutoSize

Write-Host "-------------Legenda--------------" -ForegroundColor Green
Write-Host "| Read           = Leitura       |" -ForegroundColor Green
Write-Host "| ReadAndExecute = Leitura       |" -ForegroundColor Green
Write-Host "| Synchronize    = Leitura       |" -ForegroundColor Green
Write-Host "| CreateFiles    = Leitura       |" -ForegroundColor Green
Write-Host "| AppendData     = Leitura       |" -ForegroundColor Green
Write-Host "| Modify         = Modificar     |" -ForegroundColor Green
Write-Host "| Full Control   = Controle Total|" -ForegroundColor Green
Write-Host "----------------------------------" -ForegroundColor Green  


Start-Sleep -S 50

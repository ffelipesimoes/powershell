#Lista todos os usuários que fizeram logon nos ultimos 180 dias.
$ndias = Read-Host "Defina o numero de dias a verificar"
$checktime = (get-date).adddays(-$ndias)
$caminho = Read-Host "Insira o caminho de destino (Ex: C:\temp\user.xls)"
get-aduser  -Properties LastLogonDate -filter {LastlogonDate -ge $checktime} |
Select-Object name,LastLogonDate,samaccountName |Export-Csv $caminho
Write-Host "Foi gerado com sucesso a lista dos usuários que fizeram logon nos ultimos $ndias dias. O arquivo encontra-se em $caminho"
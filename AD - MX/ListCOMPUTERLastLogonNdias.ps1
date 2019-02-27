#Lista todos as estações que se conectaram ao AD nos ultimos X dias.

$ndias = Read-Host "Defina o numero de dias a verificar"
$checktime = (get-date).adddays(-$ndias)
$caminho = Read-Host "Insira o caminho de destino (Ex: C:\temp\user.xls)"
Get-ADComputer -Properties LastLogonDate -filter {LastlogonDate -ge $checktime} |
Select-Object name,LastLogonDate  |Export-Csv $caminho
Write-Host "Foi gerado com sucesso a lista de estações que se conectaram ao AD nos ultimos $ndias dias. O arquivo encontra-se em $caminho"

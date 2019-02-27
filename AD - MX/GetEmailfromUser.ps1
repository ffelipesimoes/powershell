# ---SCRIPT PARA PEGAR EMAIL DOS USUÁRIOS ATRAVÉS DE ARQUIVO .TXT---
# 
#

# Cria uma variável para guardar as matriculas
$mat = Get-Content C:\TEMP\test.txt

# Usa função "FOREACH" para ler linha por linha do arquivo
foreach ($m in $mat) {
# Faz a consulta no AD trazendo informações de conta e email.
Get-ADUser $m -Properties mail | Select-Object  mail } 


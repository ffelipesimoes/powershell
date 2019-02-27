$filecsv = Import-Csv -Delimiter "," -Path C:\jboss-as-7.1.1.Final-8080\ListAdmin_13-10.csv -Header "Computador", "Matricula"
$filecsv = $filecsv | where {($_.matricula -notmatch "Adm") -and ($_.matricula -notmatch "Dep")}
$csv  = @"
"Computador", "Matricula", "Nome"
"@
$csv > C:\temp\echo.csv

foreach ($linha in $filecsv) {

$nome =   (Get-ADUser $linha.Matricula  -ErrorAction SilentlyContinue| select name | ft -HideTableHeaders  | Out-String).Trim()
if ($nome -eq "") { $nome = $linha.Matricula}
$csv  = @"
"$linha", "$nome"
"@
$csv >> C:\temp\echo.csv
$nome = ""
}

$teste = Get-Content C:\temp\echo.csv
$teste = $teste.Replace('"@{Computador=', '')
$teste = $teste.Replace('; Matricula=', '|,|')
$teste = $teste.Replace('}", "', '|,|')
$teste = $teste.Replace('"','|')
$teste > C:\temp\echo.csv
$new_file = Import-Csv C:\temp\echo.csv -Delimiter "," -Header "Maquina","Matricula","Nome" 
$new_file | ft -AutoSize -HideTableHeaders
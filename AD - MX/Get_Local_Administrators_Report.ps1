Get-ADGroupMember "Admin group" | Select-Object name | Export-Csv C:\TEMP\Admin group.txt
$a = Get-Content C:\TEMP\Admin group.txt
$a = $a.Replace('#TYPE Selected.Microsoft.ActiveDirectory.Management.ADPrincipal', '')
$a = $a.Replace('name', '')
$a = $a.Replace('"', '')
$a > C:\TEMP\Admin group.txt


# Lê o arquivo e informa onde será a saida
$servers= get-content 'C:\TEMP\Admin group.txt'
$output = 'c:\temp\ListAdmin.csv' 
$results = @()

foreach($server in $servers)
{
$admins = @()
$group =[ADSI]"WinNT://$server/Administradores" 
$members = @($group.psbase.Invoke("Members"))
$members | foreach {
 $obj = new-object psobject -Property @{
 Server = $Server
 Admin = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
 }
 $admins += $obj
 } 
$results += $admins
}
$results | Export-csv $Output -NoTypeInformation

#-------------------------------------------------
#Tratamento do arquivo de saida
#-------------------------------------------------

#Importando arquivo CSV e aplicando filtros
$filecsv = Import-Csv -Delimiter "," -Path c:\temp\ListAdmin.csv -Header "Computador", "Matricula"
$filecsv = $filecsv | where {($_.matricula -notmatch "Adm") -and ($_.matricula -notmatch "user")}
#Criando arquivo CSV
#$csv  = @"
#"Computador", "Matricula", "Nome"
#"@
#$csv > C:\temp\echo.csv

#tratando tratando usuários
foreach ($linha in $filecsv) {

$nome =   (Get-ADUser $linha.Matricula  -ErrorAction SilentlyContinue| select name | ft -HideTableHeaders  | Out-String).Trim()
if ($nome -eq "") { $nome = $linha.Matricula}
$csv  = @"
"$linha", "$nome"
"@
$csv >> C:\temp\echo.csv
$nome = ""
}
#formatando arquivo de saida
$new_file = Get-Content C:\temp\echo.csv
$new_file = $new_file.Replace('"@{Computador=', '')
$new_file = $new_file.Replace('; Matricula=', ',')
$new_file = $new_file.Replace('}", "', ',')
$new_file = $new_file.Replace('"','')
$new_file > C:\temp\echo.csv
$new_file = Import-Csv C:\temp\echo.csv -Delimiter "," -Header "Maquina","Matricula","Nome" 
#Exportando HTML
$html = "<style>"
$html = $html + "BODY{background-color:#7FFFD4;}"
$html = $html + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$html = $html + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:#EEDD82}"
$html = $html + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:#20B2AA}"
$html = $html + "</style>"


$new_file | ConvertTo-HTML -head $html -body "<H2> Lista de administradores das estações</H2>"  | Out-File C:\temp\List.html


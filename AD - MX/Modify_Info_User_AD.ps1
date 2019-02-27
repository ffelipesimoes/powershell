$list = Import-Csv 'C:\Users\user\Downloads\Lista - Genericos.csv' -Delimiter "," -Header "Nome","Matricula", "Expira", "Ativado","OBS"

foreach ($l in $list){ Get-ADUser $l.Matricula -Properties * | ft samaccountname, info }


SET-ADUSER user –replace @{info=”John Smith is a Temporary Contractor”}

Get-ADUser user -Properties info
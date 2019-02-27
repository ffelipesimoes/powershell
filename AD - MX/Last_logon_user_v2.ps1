$checktime = (get-date).adddays(-60)
$list_user =  get-aduser  -Properties LastLogonDate -filter {LastlogonDate -ge $checktime} | Select-Object name,LastLogonDate,samaccountName 
($list_user  | Where-Object -FilterScript {$_.SamaccountName -match "P7"}).count
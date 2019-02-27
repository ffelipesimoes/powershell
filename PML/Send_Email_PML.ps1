Set-ExecutionPolicy -ExecutionPolicy Unrestricted
$from = "usergroup@domain"
$to = "group@domain","group1@domain"
$cc = "group1@domain"
$subject = "subject" 
$smtpserver = "webmail.domain"
$body = Get-Content C:\temp\teste.html -Raw # mandando arquivo HTML via email
#Get-ADUser -Id user | Out-String
#para textos use o -raw com o get-content
#$body += "horario"

Send-MailMessage -From $from -To $to -Cc $cc  -Subject $subject -SmtpServer $smtpserver -Body $body -BodyAsHtml


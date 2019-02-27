$from = "user@domain"
$to = "user@domain"
$subject = "Test email"
$smtpserver = "webmail.domain"
$body = Get-Content C:\temp\List.html -Raw # mandando arquivo HTML via email
#Get-ADUser -Id user | Out-String
#para textos use o -raw com o get-content


Send-MailMessage -From $from -To $to -Subject $subject -SmtpServer $smtpserver -Body $body -BodyAsHtml

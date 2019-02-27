#Criar sessão na console Exchange
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://maiboxserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session

#Ver databases disponiveis
Get-MailboxDatabase 


#Definição de email antigo e email novo e database
$OldMailbox = "Fulano de tal"
$NewMailbox = "9130861a"
$database = "Database-geral"

#Desabilitando email antigo
disable-Mailbox -Identity $oldmailbox -Confirm:$false

#Limpando "cache" do mailbox
Clean-MailboxDatabase $database

#Conectando mailbox à novo usuário
Connect-Mailbox -Identity $OldMailbox -Database $database -User $NewMailbox 

Get-Mailbox "Fulano de tal"

#Limpando "cache" do mailbox
Clean-MailboxDatabase $database

#Checando se mailbox foi transferido com sucesso
Get-Mailbox -Identity $NewMailbox | ft name,database
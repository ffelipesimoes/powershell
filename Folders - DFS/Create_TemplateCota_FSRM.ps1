Enter-PSSession -ComputerName #ServerFSRM

#Ver cotas do servidor
Get-FsrmQuotaTemplate | ft name,size,softlimit

#Criando template de cotas simples
New-FsrmQuotaTemplate -Name "20GB limite - teste" -Description "Cota teste" -Size 20GB  #caso a cota seja flexivel -SoftLimit


#Criando templates completos
#Quota Templates
$template10GB = "10GB_User_Limit-teste"
$template10GB_ext= "10GB_User_Limit_500MB_Extension-teste"
#Create FSRMActions
$FSRMActionEvent = New-FsrmAction Event -EventType Information -Body "O usuario [Source Io Owner] excedeu a [Quota Threshold]% quota threshold para a pasta [Quota Path] no servidor [Server]. A cota limite é [Quota Limit MB] MB, e [Quota Used MB] MB atualmente é ([Quota Used Percent]% do limite)."	
$FSRMActionEmail = New-FsrmAction Email -MailTo "[Source Io Owner Email]" -Subject "[Quota Threshold]% quota limite excedida" -Body "Usuário [Source Io Owner] excedeu [Quota Threshold]% quota limite para a pasta [Quota Path] no servidor [Server]. A quota limite é [Quota Limit MB] MB, e [Quota Used MB] MB atualmente é ([Quota Used Percent]% do limite)."
$FSRMActionEmail_100 = New-FsrmAction Email -MailTo "[Source Io Owner Email]" -Subject "[Quota Threshold]% quota limite excedida" -Body "Usuário [Source Io Owner] alcançou o limite de cota na pasta [Quota Path] no servidor [Server]. A quota limite é [Quota Limit MB] MB e o atual uso é [Quota Used MB] MB ([Quota Used Percent]% of limit). Uma extensão automática foi concedido de 500 MB."
$FSRMActionEvent_100 = New-FsrmAction Event -EventType Information -Body "[Source Io Owner] has reached the quota limit for quota on [Quota Path] on server [Server]. An automatic one-time extension of 500 MB has been granted."
$FSRMActionCommand = New-FsrmAction Command -Command "%windir%\system32\dirquota.exe" -CommandParameters "quota modify /path:[Quota Path] /sourcetemplate:$template10GB_ext" -KillTimeOut 1 -SecurityLevel LocalSystem
#Quota thresholds
$Threshold_80 = New-FsrmQuotaThreshold -Percentage 80 -action $FSRMActionEvent, $FSRMActionEmail
$Threshold_95 = New-FsrmQuotaThreshold -Percentage 95 -action $FSRMActionEvent, $FSRMActionEmail
$Threshold_100 = New-FsrmQuotaThreshold -Percentage 100 -action $FSRMActionEvent_100, $FSRMActionEmail_100, $FSRMActionCommand
#Create quota template
New-FsrmQuotaTemplate -name $template10GB -Description $template10GB -size 10GB -Threshold $Threshold_80, $Threshold_95, $Threshold_100

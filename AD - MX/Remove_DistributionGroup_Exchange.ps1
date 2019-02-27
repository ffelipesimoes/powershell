$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://exchangeserver/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
#consultar grupo
#Get-DistributionGroup -Identity "folha*"

#remover grupo
Remove-DistributionGroup -Identity group@domain
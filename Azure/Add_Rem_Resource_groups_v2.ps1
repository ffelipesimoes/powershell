Import-Module 'G:\Scripts\Powershell Modules\goto-azure.psm1'
goto-azure

#select your subscription
$subscription =  Get-AzureRmSubscription | Out-GridView -PassThru
Select-AzureRmSubscription -SubscriptionName  $subscription 

#Get Subscriptions
Get-AzureRmResourceGroup

#Create Resources Groups
new-AzureRmResourceGroup -Name Cloud_Datacenter -Location 'West Europe'

#remove Resources Groups
Remove-AzureRmResourceGroup -Name Cloud_Datacenter
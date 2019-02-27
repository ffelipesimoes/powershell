Add-AzureAccount
Get-AzureSubscription
$subs = Get-AzureSubscription
$subs = $subs.SubscriptionName
Select-AzureSubscription -SubscriptionName $subs -Current

Switch-AzureMode AzureResourceManager
Get-AzureResourceGroup | where {$_.ResourceGroupName -notcontains 'infrastructure'} #| Remove-AzureResourceGroup -Force


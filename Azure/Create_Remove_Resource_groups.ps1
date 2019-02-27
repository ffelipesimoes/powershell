
$subs = Get-AzureRmSubscription | fl name
$subs = $subs.SubscriptionName
Select-AzureSubscription -SubscriptionName $subs -Current

Switch-AzureMode AzureResourceManager
Get-AzureResourceGroup | where {$_.ResourceGroupName -notcontains 'infrastructure'} #| Remove-AzureResourceGroup -Force


Get-AzureAccount
New-AzureVirtualNetwork -Name "Public" -ResourceGroupName "Infrastructure" -Location "westeurope" -AddressPrefix "192.168.0.0/16" 
Get-AzureResourceGroup
Get-AzureSubscription

Get-AzureVirtualNetwork

New-AzureVirtualNetworkSubnetConfig - "Private" -Name "Workstations" -AddressPrefix "10.0.1.0/24" 

Import-Module 'G:\Scripts\Powershell Modules\goto-azure.psm1'
goto-azure

# Define Global settings: Location, ResourceGroup.
$location = "westeurope"
#$resourceGroup = Get-AzureRmResourceGroup | Out-GridView -PassThru
$resourceGroup = "Cloud_Datacenter"

##Define Subnet settings
$VNName = Get-AzureRmVirtualNetwork | where {$_.Name -eq 'VN_Public'}
$SubnetName = "SN_VPN"
$SubnetAddressPrefix = "192.168.30.0/24"

#Create Subnet
$subnetConfig = add-AzureRmVirtualNetworkSubnetConfig `
  -Name $SubnetName `
  -AddressPrefix $SubnetAddressPrefix `
  -VirtualNetwork $VNName

#Attaching Subnet to Virtual Network
$VNName | Set-AzureRmVirtualNetwork


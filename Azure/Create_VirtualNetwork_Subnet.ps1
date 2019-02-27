Import-Module 'G:\Scripts\Powershell Modules\goto-azure.psm1'
goto-azure

# Define Global settings: Location, ResourceGroup.
$location = "westeurope"
#$resourceGroup = Get-AzureRmResourceGroup | Out-GridView -PassThru
$resourceGroup = "Cloud_Datacenter"

#Define Virtual Network settings
$VNName = "VN_Public"
$VNAddressPrefix = "192.168.0.0/16"

##Define Subnet settings
$SubnetName = "SN_FrontEnd"
$SubnetAddressPrefix = "192.168.10.0/24"

#Create Virtual Network
$virtualNetwork = New-AzureRmVirtualNetwork `
  -ResourceGroupName $resourceGroup `
  -Location $location `
  -Name $VNName `
  -AddressPrefix $VNAddressPrefix

#Create Subnet
$subnetConfig = Add-AzureRmVirtualNetworkSubnetConfig `
  -Name $SubnetName `
  -AddressPrefix $SubnetAddressPrefix `
  -VirtualNetwork $virtualNetwork

#Attaching Subnet to Virtual Network
  $virtualNetwork | Set-AzureRmVirtualNetwork
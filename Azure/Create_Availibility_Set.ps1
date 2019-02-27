Import-Module 'G:\Scripts\Powershell Modules\goto-azure.psm1'
goto-azure

# Define Global settings: Location, ResourceGroup.
$location = "westeurope"
#$resourceGroup = Get-AzureRmResourceGroup | Out-GridView -PassThru
$resourceGroup = "Cloud_Datacenter"


# Define Availability Set settings
$ASName = "AS_Infrastructure"
$Sku = "aligned"
$PlatformFaultDomainCount = 2
$PlatformUpdateDomainCount = 2

New-AzureRmAvailabilitySet `
   -Location $location `
   -Name $ASName `
   -ResourceGroupName $resourceGroup `
   -Sku $Sku `
   -PlatformFaultDomainCount $PlatformFaultDomainCount `
   -PlatformUpdateDomainCount $PlatformUpdateDomainCount

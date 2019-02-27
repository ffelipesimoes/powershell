Import-Module 'G:\Scripts\Powershell Modules\goto-azure.psm1'
goto-azure

# Define Location.
$location = "westeurope"

# Define resource group.
#$resourceGroup = Get-AzureRmResourceGroup | Out-GridView -PassThru
$resourceGroup = "Cloud_Datacenter"


# Set the name of the storage account, SKU name and Kind. 
$storageAccountName = "felipescompanyvm"
$skuName = "Premium_LRS"
$kind = "StorageV2"


# Create the storage account.
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageAccountName `
  -Location $location `
  -SkuName $skuName `  -Kind $kind
  


# Retrieve the context. 
$ctx = $storageAccount.Context
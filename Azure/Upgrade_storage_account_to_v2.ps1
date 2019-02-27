Import-Module 'G:\Scripts\Powershell Modules\goto-azure.psm1'
goto-azure

# Define resource group.
#$resourceGroup = Get-AzureRmResourceGroup | Out-GridView -PassThru
$resourceGroup = "Cloud_Datacenter"
$storageAccount = "userscompanydefault"


Set-AzureRmStorageAccount -ResourceGroupName $resourceGroup -AccountName $storageAccount -UpgradeToStorageV2
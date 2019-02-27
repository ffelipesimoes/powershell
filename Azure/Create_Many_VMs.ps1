Import-Module 'G:\Scripts\Powershell Modules\goto-azure.psm1'
goto-azure

#How many machines create?
$number = 2

# Define Global settings: Location, ResourceGroup.
$location = "westeurope"
$resourceGroup = Get-AzureRmResourceGroup | Out-GridView -PassThru
#$resourceGroup = "Cloud_Datacenter"


for ($i=1; $i -le $number; $i++)
{
    New-AzureRmVm `
        -ResourceGroupName $resourceGroup `
        -Name "Server0$i" `
        -Location $location `
        -VirtualNetworkName "myVnet" `
        -SubnetName "mySubnet" `
        -SecurityGroupName "myNetworkSecurityGroup" `
        -PublicIpAddressName "myPublicIpAddress$i" `
        -AvailabilitySetName "myAvailabilitySet" `
        -Credential $cred
}
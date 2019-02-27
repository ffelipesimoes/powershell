# Deploy Azure Load Balancer with IPv6
# Ref: timw.info/ipv6

# Set environment
Import-Module 'G:\Scripts\Powershell Modules\goto-azure.psm1'
goto-azure

$resourceGroup = "Cloud_Datacenter_Branch"
$location = "East Us"
Select-AzureRmSubscription -SubscriptionName 'Main Office'
New-AzureRmResourceGroup -Name $resourceGroup -location $location

# Vnet with a subnet
##Define Subnet settings
$VNName = "VN_Private"
$backendSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name "SN_Servers" -AddressPrefix "10.2.0.0/24"
$backendSubnet2 = New-AzureRmVirtualNetworkSubnetConfig -Name "SN_Workstations" -AddressPrefix "10.2.10.0/24"
$vnet = New-AzureRmvirtualNetwork -Name $VNName -ResourceGroupName $resourceGroup -Location $location -AddressPrefix "10.2.0.0/16" -Subnet $backendSubnet,$backendSubnet2

# public IP for front-end LB pool
$publicIPv4Name = "litecoin-ipv4"
$publicIPv4 = New-AzureRmPublicIpAddress -Name $publicIPv4Name -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Dynamic -IpAddressVersion IPv4 # -DomainNameLabel litecoin-ipv4
#$publicIPv6 = New-AzureRmPublicIpAddress -Name 'pub-ipv6' -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Dynamic -IpAddressVersion IPv6 -DomainNameLabel lbnrpipv6

$publicIPv4Name2 = "holder-ipv4"
$publicIPv4 = New-AzureRmPublicIpAddress -Name $publicIPv4Name2 -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Dynamic -IpAddressVersion IPv4 # -DomainNameLabel holder-ipv4

# front-end address config
#$FEIPConfigv4 = New-AzureRmLoadBalancerFrontendIpConfig -Name "LB-Frontendv4" -PublicIpAddress $publicIPv4
#$FEIPConfigv6 = New-AzureRmLoadBalancerFrontendIpConfig -Name "LB-Frontendv6" -PublicIpAddress $publicIPv6

# back-end address pools
#$backendpoolipv4 = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "BackendPoolIPv4"
#$backendpoolipv6 = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "BackendPoolIPv6"

# NAT rules
#$inboundNATRule1v4 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name "NicNatRulev4" -FrontendIpConfiguration $FEIPConfigv4 -Protocol TCP -FrontendPort 443 -BackendPort 4443
#$inboundNATRule1v6 = New-AzureRmLoadBalancerInboundNatRuleConfig -Name "NicNatRulev6" -FrontendIpConfiguration $FEIPConfigv6 -Protocol TCP -FrontendPort 443 -BackendPort 4443

# HTTP probe
#$healthProbe = New-AzureRmLoadBalancerProbeConfig -Name 'HealthProbe-v4v6' -RequestPath 'HealthProbe.aspx' -Protocol http -Port 80 -IntervalInSeconds 15 -ProbeCount 2

# or TCP probe
#$healthProbe = New-AzureRmLoadBalancerProbeConfig -Name 'HealthProbe-v4v6' -Protocol Tcp -Port 8080 -IntervalInSeconds 15 -ProbeCount 2
#$RDPprobe = New-AzureRmLoadBalancerProbeConfig -Name 'RDPprobe' -Protocol Tcp -Port 3389 -IntervalInSeconds 15 -ProbeCount 2

# LB rule
#$lbrule1v4 = New-AzureRmLoadBalancerRuleConfig -Name "HTTPv4" -FrontendIpConfiguration $FEIPConfigv4 -BackendAddressPool $backendpoolipv4 -Probe $healthProbe -Protocol Tcp -FrontendPort 80 -BackendPort 8080
#$lbrule1v6 = New-AzureRmLoadBalancerRuleConfig -Name "HTTPv6" -FrontendIpConfiguration $FEIPConfigv6 -BackendAddressPool $backendpoolipv6 -Probe $healthProbe -Protocol Tcp -FrontendPort 80 -BackendPort 8080
#$RDPrule = New-AzureRmLoadBalancerRuleConfig -Name "RDPrule" -FrontendIpConfiguration $FEIPConfigv4 -BackendAddressPool $backendpoolipv4 -Probe $RDPprobe -Protocol Tcp -FrontendPort 3389 -BackendPort 3389

# deploy the LB
#$NRPLB = New-AzureRmLoadBalancer -ResourceGroupName $resourceGroup -Name 'myNrpIPv6LB' -Location $location -FrontendIpConfiguration $FEIPConfigv4,$FEIPConfigv6 -InboundNatRule $inboundNATRule1v6,$inboundNATRule1v4 -BackendAddressPool $backendpoolipv4,$backendpoolipv6 -Probe $healthProbe,$RDPprobe -LoadBalancingRule $lbrule1v4,$lbrule1v6,$RDPrule

# get reference to Vnet and subnet
#$vnet = Get-AzureRmVirtualNetwork -Name "VN_Private" -ResourceGroupName $resourceGroup
#$backendSubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name LB-Subnet-BE -VirtualNetwork $vnet
#-------------------------------------------------------------------------------
#ERROR-ERROR-ERRORERROR-ERROR-ERROR-ERROR#ERROR-ERROR-ERRORERROR-ERROR-ERROR-ERROR
<#

# create IP configs for VMs
$VNName = Get-AzureRmVirtualNetwork | where {$_.Name -eq 'VN_Private'}
$nic1IPv4 = New-AzureRmNetworkInterfaceIpConfig -Name "IPv4IPConfig" -PrivateIpAddressVersion "IPv4" -Subnet SN_Servers
#$nic1IPv6 = New-AzureRmNetworkInterfaceIpConfig -Name "IPv6IPConfig" -PrivateIpAddressVersion "IPv6" -LoadBalancerBackendAddressPool $backendpoolipv6 -LoadBalancerInboundNatRule $inboundNATRule1v6
$nic1 = New-AzureRmNetworkInterface -Name 'Private_IP_litecoin' -IpConfiguration $nic1IPv4 -ResourceGroupName $resourceGroup -Location $location

$nic2IPv4 = New-AzureRmNetworkInterfaceIpConfig -Name "IPv4IPConfig" -PrivateIpAddressVersion "IPv4" -Subnet "SN_Workstations"
#$nic2IPv6 = New-AzureRmNetworkInterfaceIpConfig -Name "IPv6IPConfig" -PrivateIpAddressVersion "IPv6" -LoadBalancerBackendAddressPool $backendpoolipv6
$nic2 = New-AzureRmNetworkInterface -Name 'Holder' -IpConfiguration $nic2IPv4 -ResourceGroupName $resourceGroup -Location $location

#>
#ERROR-ERROR-ERRORERROR-ERROR-ERROR-ERROR#ERROR-ERROR-ERRORERROR-ERROR-ERROR-ERROR
#-------------------------------------------------------------------------------

# Get the VNET to which to connect the NIC
$VNET = Get-AzureRmVirtualNetwork -Name ‘VN_Private’ -ResourceGroupName ‘Cloud_Datacenter_branch’
# Get the Subnet ID to which to connect the NIC
$SubnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name ‘SN_Servers’ -VirtualNetwork $VNET).Id
# NIC Name
$NICName = ‘litecoin-nic1’
#Enter the IP address if you want
#$IPAddress = ‘10.20.30.21’

$publicIPv4id =  Get-AzureRmPublicIpAddress -Name $publicIPv4Name -ResourceGroupName $resourceGroup
#–> Create now the NIC Interface

$nic1 = New-AzureRmNetworkInterface -Name $NICName -ResourceGroupName $resourceGroup -Location $Location -SubnetId $SubnetID -PublicIpAddressId $publicIPv4id.Id  # -PrivateIpAddress $IPAddress



# Get the VNET to which to connect the NIC
$VNET = Get-AzureRmVirtualNetwork -Name ‘VN_Private’ -ResourceGroupName ‘Cloud_Datacenter_branch’
# Get the Subnet ID to which to connect the NIC
$SubnetID2 = (Get-AzureRmVirtualNetworkSubnetConfig -Name ‘SN_Workstations’ -VirtualNetwork $VNET).Id
# NIC Name
$NICName2 = ‘holder-nic1’
#Enter the IP address if you want
#$IPAddress = ‘10.20.30.21’

$publicIPv42id =  Get-AzureRmPublicIpAddress -Name $publicIPv4Name2 -ResourceGroupName $resourceGroup
#–> Create now the NIC Interface

$nic2 = New-AzureRmNetworkInterface -Name $NICName2 -ResourceGroupName $resourceGroup -Location $Location -SubnetId $SubnetID2 -PublicIpAddressId $publicIPv42id.Id  # -PrivateIpAddress $IPAddress


# Create availability set and storage account
New-AzureRmAvailabilitySet -Name 'AS_Infrastructure' -ResourceGroupName $resourceGroup -Location $location
$availabilitySet = Get-AzureRmAvailabilitySet -Name 'AS_Infrastructure' -ResourceGroupName $resourceGroup
New-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name 'felipescompanydefault2' -Location $location -SkuName "Standard_LRS"
$CreatedStorageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name 'felipescompanydefault2'

# Create each VM and associate vNICs
$mySecureCredentials= Get-Credential -Message "Type the username and password of the local administrator account."

$vm1 = New-AzureRmVMConfig -VMName 'Litecoin' -VMSize 'Standard_D1_v2' -AvailabilitySetId $availabilitySet.Id
$vm1 = Set-AzureRmVMOperatingSystem -VM $vm1 -Windows -ComputerName 'Litecoin' -Credential $mySecureCredentials -ProvisionVMAgent -EnableAutoUpdate
$vm1 = Set-AzureRmVMSourceImage -VM $vm1 -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version "latest"
$vm1 = Add-AzureRmVMNetworkInterface -VM $vm1 -Id $nic1.Id -Primary 
$osDisk1Uri = $CreatedStorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/Litecoin_osdisk.vhd"
$vm1 = Set-AzureRmVMOSDisk -VM $vm1 -Name 'Litecoin_osdisk' -VhdUri $osDisk1Uri -CreateOption FromImage
New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vm1 

$vm2 = New-AzureRmVMConfig -VMName 'Holder' -VMSize 'Standard_D1_v2' -AvailabilitySetId $availabilitySet.Id
$vm2 = Set-AzureRmVMOperatingSystem -VM $vm2 -Windows -ComputerName 'Holder' -Credential $mySecureCredentials -ProvisionVMAgent -EnableAutoUpdate
$vm2 = Set-AzureRmVMSourceImage -VM $vm2 -PublisherName MicrosoftWindowsDesktop -Offer Windows-10 -Skus RS3-Pro -Version "latest"
$vm2 = Add-AzureRmVMNetworkInterface -VM $vm2 -Id $nic2.Id -Primary
$osDisk2Uri = $CreatedStorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/Holder_osdisk.vhd"
$vm2 = Set-AzureRmVMOSDisk -VM $vm2 -Name 'Holder_osdisk' -VhdUri $osDisk2Uri -CreateOption FromImage
New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vm2

# Clean up (careful!)
#Remove-AzureRmResourceGroup -Name 'Cloud_Datacenter_branch' -Force



#New-AzureRmResourceGroup -Name NRP-RGtest -location "West US"
#Remove-AzureRmResourceGroup -Name 'NRP-RGtest' -Force -verbose
# Criando sessão remota no servidor
Enter-PSSession -ComputerName "wsusserver" -Credential 400062u@domain

# Connection with WSUS Server
$Computername = 'wsusserver'
$UseSSL = $False
$Port = 8530

[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Computername,$UseSSL,$Port)

#-------------------------------------
# See methods Wsus
$wsus | Get-Member –Type Method
#-------------------------------------
# Find a computer on WSUS
$wsus.GetComputerTargetByName(“ttjdeinf0153745.domain”) | ft fulldomainname, IPaddress, OSDescription, LastSyncResult, LastSyncTime 
#-------------------------------------
# Query many clients by short name
$wsus.SearchComputerTargets("tj") | ft fulldomainname, IPaddress, OSDescription, LastSyncResult, LastSyncTime
#-------------------------------------
# Find computer by SSID
$wsus.GetComputerTarget([guid]” ac6ccbaa-67d4-4807-ae52-0999d0b34673”)
#-------------------------------------
# Show all computers managed by WSUS 
$wsus.GetComputerTargets() | ft fulldomainname, IPaddress, OSDescription, LastSyncResult, LastSyncTime
#-------------------------------------
# Liberate information of methods
$Client = $wsus.SearchComputerTargets(“computer.domain")
$Client.GetType().ToString()
$client[0].GetType().ToString()
#-------------------------------------
# Show groups of WSUS
$wsus.GetComputerTargetGroups() | Select-Object name
$wsus.GetComputerTargetGroup([guid]” a0a08746-4dbe-4a37-9adf-9e7652c0b421”) 
#-------------------------------------
# Creating a new target group and creating new target group child
$wsus.CreateComputerTargetGroup(“TESTGROUP”)
$group = $wsus.GetComputerTargetGroups() | Where {$_.Name –eq “TESTGROUP”}
$wsus.CreateComputerTargetGroup(“CHILDGROUP”,$group)
$wsus.GetComputerTargetGroups()
#-------------------------------------
# Removing a new target group and creating new target group child
$group = $wsus.GetComputerTargetGroups() | Where {$_.Name –eq “CHILDGROUP”}
$group.Delete()
#-------------------------------------
#Adding a client to a target group
$Client = $wsus.SearchComputerTargets(“target")
$group = $wsus.GetComputerTargetGroups() | Where {$_.Name –eq “Nome do grupo”}
$group.AddComputerTarget($client[0])
#-------------------------------------
#Removing a client to a target group
$Client = $wsus.SearchComputerTargets(“DC1")
$group = $wsus.GetComputerTargetGroups() | Where {$_.Name –eq “TESTGROUP”}
$group.RemoveComputerTarget($client[0])
$client[0].GetComputerTargetGroups()


# Show all updates in WSUS
$Wsus.GetUpdates() | fl KnowledgebaseArticles,Description, ProductTitles,Title, CreationDate, UpdateClassificationTitle
$Wsus.GetUpdates()  | Sort-Object {$_.CreationDate} |Where-Object -FilterScript {$_.ProductTitles -match "Windows XP"} | ft -AutoSize KnowledgebaseArticles,CreationDate,ProductTitles,IsApproved
# Show status WSUS synchronization
$wsus.GetSubscription() | ft -AutoSize   LastModifiedTime, LastModifiedBy, LastSynchronizationTime, SynchronizeAutomatically

# Start WSUS synchronization
$subscription = $wsus.GetSubscription()
$subscription.StartSynchronization()
$subscription.GetSynchronizationProgress() # see progress

# Searching Update
$update = $wsus.SearchUpdates('Windows 8')  |ft -AutoSize KnowledgebaseArticles, CreationDate, ProductTitles, IsApproved | Sort-Object {$_.CreationDate}
$update.count
$update | Select Title

# show Updates with Accepting license agreements
$license = $update | Where {$_.RequiresLicenseAgreementAcceptance}
$license | Select Title
$license | ForEach {$_.AcceptLicenseAgreement()}

# Approving updates
$update = $wsus.SearchUpdates(‘Windows 7 for x64-based Systems (KB2639417)’) # Nome do KB ou atualização
$group = $wsus.GetComputerTargetGroups() | where {$_.Name -eq ‘TESTGROUP’} # nome do grupo que será liberado a atualização
$update[0].ApproveForOptionalInstall($Group) # aprovando atualização como opcional para o grupo informado

[Microsoft.UpdateServices.Administration.UpdateApprovalAction] | gm -static -Type Property | Select –expand Name

$update = $wsus.SearchUpdates(‘Update for 2007 Microsoft Office System (KB932080)’) # Nome do KB ou atualização
$group = $wsus.GetComputerTargetGroups() | where {$_.Name -eq ‘TESTGROUP’} # nome do grupo que será liberado a atualização
$update[0].Approve(“Install”,$Group) # aprovando atualização para o grupo informado

# Declining Updates
$update = $wsus.SearchUpdates(‘932080’)
$update[0].Decline()

#Status geral das atualizações das estações no Wsus
$computerscope = New-Object Microsoft.UpdateServices.Administration.ComputerTargetScope
$wsus.GetComputerTargets($computerscope)

# listando maquinas e status de updates
$updates = $wsus.SearchUpdates("")
$update = $updates[0]
$update.GetSummary($computerscope)
$Wsus.GetComputerStatus($computerscope,[ Microsoft.UpdateServices.Administration.UpdateSources]::All)
$update.GetUpdateInstallationInfoPerComputerTarget($ComputerScope)

$update.GetUpdateInstallationInfoPerComputerTarget($ComputerScope) |
 Select @{L=’Client';E={$wsus.GetComputerTarget(([guid]$_.ComputerTargetId)).FulldomainName}},
@{L=’TargetGroup';E={$wsus.GetComputerTargetGroup(([guid]$_.UpdateApprovalTargetGroupId)).Name}},
 @{L=’Update';E={$wsus.GetUpdate(([guid]$_.UpdateId)).Title}}, UpdateInstallationState,UpdateApprovalAction |ft Client, targetgroup , update, UpdateInstallationState, UpdateApprovalAction


 $updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope

 $updatescope.ApprovedStates = [Microsoft.UpdateServices.Administration.ApprovedStates]::NotApproved

$updatescope.IncludedInstallationStates = [Microsoft.UpdateServices.Administration.UpdateInstallationStates]::NotInstalled

$updatescope.FromArrivalDate = [datetime]"12/13/2011"

$wsus.GetUpdateCount($updatescope)
$wsus.GetUpdateStatue($updatescope,$False)
$wsus.GetUpdates($updatescope) | Select Title

########################################################################################
########################################################################################
########################################################################################
########################################################################################
# RELATÓRIO GERAL DE ESTAÇÕES E UPDATES

$computerscope = New-Object Microsoft.UpdateServices.Administration.ComputerTargetScope

$updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope

$wsus.GetSummariesPerComputerTarget($updatescope,$computerscope) |

    Format-Table @{L=’ComputerTarget';E={($wsus.GetComputerTarget([guid]$_.ComputerTargetId)).FullDomainName}},

        @{L=’NeededCount';E={($_.DownloadedCount + $_.NotInstalledCount)}},DownloadedCount,NotApplicableCount,NotInstalledCount,InstalledCount,FailedCount

########################################################################################
########################################################################################
########################################################################################
########################################################################################

$updatescope.ApprovedStates = [Microsoft.UpdateServices.Administration.ApprovedStates]::NotApproved

$updatescope.IncludedInstallationStates = [Microsoft.UpdateServices.Administration.UpdateInstallationStates]::NotInstalled

$updatescope.FromArrivalDate = [datetime]”12/13/2015"   

$wsus.GetSummariesPerUpdate($updatescope,$computerscope) |

    Format-Table @{L=’UpdateTitle';E={($wsus.GetUpdate([guid]$_.UpdateId)).Title}},

        @{L=’NeededCount';E={($_.DownloadedCount + $_.NotInstalledCount)}},DownloadedCount,NotApplicableCount,NotInstalledCount,InstalledCount,FailedCount




        Get-WsusComputer -NameIncludes "TTJDEINF0153710"

Get-WSUSUpdate | Select -first 5 | Select Title, KnowledgeBaseArt

(Get-WsusUpdate -Classification Critical -Approval Approved -Status Any).count
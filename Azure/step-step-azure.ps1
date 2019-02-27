Install-Module -Name AzureRM -AllowClobber
Import-Module -Name AzureRM
# sign in
Write-Host "Logging in...";
Login-AzureRmAccount

Param (
[Parameter(Mandatory=$true)][string]$usuario
)

$user = get-aduser $usuario
Write-Output $user.Name


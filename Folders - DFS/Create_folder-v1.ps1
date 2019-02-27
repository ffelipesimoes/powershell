$Path = Read-Host "Informe o nome da pasta"
$Read_perm = Read-Host "Informe o Grupo com permissão de Leitura"
$Modify_perm = Read-Host "Informe o Grupo com permissão para Modificar"

# create new folder
New-Item -Path "\\server\d$\dados\$Path" -ItemType Directory
#$Shares=[WMICLASS]”WIN32_Share”
#$Shares.Create(“d:\$path”,”$path”,0)
cmd /c "net share $path=d:\dados\$path /GRANT:everyone,CHANGE"
#Invoke-Command –ComputerName "server" –ScriptBlock{cmd /c "net share teste=d:\dados\teste /GRANT:everyone,CHANGE"}
#Invoke-Command –ComputerName "server" –ScriptBlock{cmd /c "hostname"}

$acl = Get-Acl \\server\d$\dados\$Path 
$acl.SetAccessRuleProtection($True, $False)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("domain admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$modify_perm","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$read_perm","Read", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
Set-Acl \\server\d$\dados\$path  $acl

Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Green
Write-Host "| Foi criado o compartilhamento \\server\$path                            |" -ForegroundColor Green
Write-Host "| Foi adicionado o Grupo $Read_perm  com permissão de Leitura na pasta         |" -ForegroundColor Green
Write-Host "| Foi adicionado o Grupo $Modify_perm  com permissão para Modificar na pasta   |" -ForegroundColor Green
Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Green  


Start-Sleep -S 50

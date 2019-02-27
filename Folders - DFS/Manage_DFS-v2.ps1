#Enter-PSSession -ComputerName server
Invoke-Command  -ComputerName "server" -ScriptBlock{
$path = "D:\share2\testenovo"
New-Item -type directory -path $path
$Acl = Get-Acl $path
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("domain\useru","Modify",”ContainerInherit,ObjectInherit”,”None”,"Allow")
$Acl.SetAccessRule($Ar)
Set-Acl $path $Acl
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("domain\user","Read",”ContainerInherit,ObjectInherit”,”None”,"Allow")
$Acl.SetAccessRule($Ar)
Set-Acl $path $Acl






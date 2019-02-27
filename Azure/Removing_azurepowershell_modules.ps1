foreach ($module in (Get-Module -ListAvailable Azure*).Name |Get-Unique) {

write-host "Removing Module $module"

Uninstall-module $module

}
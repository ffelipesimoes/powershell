Get-ADGroup -Identity "GroupName"

$list = Get-Content C:\temp\list.txt
foreach ($l in $list) {
Add-ADGroupMember -Identity "GroupName" -Members $l
}
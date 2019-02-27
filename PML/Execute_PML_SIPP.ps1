$results = net file | Select-String -SimpleMatch "D:\Sistem\program.exe"
foreach ($result in $results) {
    #Get id
    $id = $result.Line.Split(" ")[0]

    #Close file
    net file $id /close

}

$date = Get-Date -Format d
$date = $date.Replace('/', '')
$path = "D:\Sistem\program-"
$newpath = "program-" + $date + ".exe"
# Renomeia arquivo inserindo data no final
Rename-Item D:\Sistem\program.exe $newpath
#Get-ChildItem D:\Sistem\program.exe
# Copia arquivo novo para destino
Copy-Item D:\Sistem\New\program.exe D:\Sistem\program.exe
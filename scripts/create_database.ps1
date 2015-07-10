Param(
    [string]$projectName = "ProjectName",
    [string]$databaseType = "MSSQL"
)

$scriptDirectory = $PSScriptRoot
$executionPath = convert-path .
$resourceDirectory = "$scriptDirectory\resources\create_database\"
write-host "Script $scriptDirectory called from $executionPath"
new-item "$executionPath\$projectName.Database" -type directory
new-item "$executionPath\$projectName.Database\schema" -type directory
new-item "$executionPath\$projectName.Database\tools" -type directory
new-item "$executionPath\$projectName.Database\functions" -type directory
new-item "$executionPath\$projectName.Database\views" -type directory
new-item "$executionPath\$projectName.Database\procedures" -type directory
new-item "$executionPath\$projectName.Database\data" -type directory
new-item "$executionPath\$projectName.Database\assembly-scripts" -type directory 

copy-item "$resourceDirectory\build-database-script.ps1" "$executionPath\$projectName.Database\"
copy-item "$resourceDirectory\readme.txt" "$executionPath\$projectName.Database\readme.txt"
copy-item "$resourceDirectory\tools\database.exe" "$executionPath\$projectName.Database\tools\database.exe"
copy-item "$resourceDirectory\tools\database.exe.config" "$executionPath\$projectName.Database\tools\database.exe.config"
copy-item "$resourceDirectory\views\v_tables.sql" "$executionPath\$projectName.Database\views\v_tables.sql"
copy-item "$resourceDirectory\functions\fn_tables.sql" "$executionPath\$projectName.Database\functions\fn_tables.sql"
copy-item "$resourceDirectory\procedures\usp_tables.sql" "$executionPath\$projectName.Database\procedures\usp_tables.sql"



$scriptOne = $projectName + "_0_0_00_0.sql"
$scriptTwo = $projectName + "_1_0_00_0.sql"

copy-item "$resourceDirectory\schema\Sample_0_0_00_0.sql" "$executionPath\$projectName.Database\schema\$scriptOne"
copy-item "$resourceDirectory\schema\Sample_1_0_00_0.sql" "$executionPath\$projectName.Database\schema\$scriptTwo"

(Get-Content "$executionPath\$projectName.Database\schema\$scriptOne") |
 ForEach-Object {$_ -replace "PROJECTNAME", $projectName.ToUpper()} |
 set-content "$executionPath\$projectName.Database\schema\$scriptOne"

(Get-Content "$executionPath\$projectName.Database\schema\$scriptTwo") |
 ForEach-Object {$_ -replace "PROJECTNAME", $projectName.ToUpper()} |
 set-content "$executionPath\$projectName.Database\schema\$scriptTwo"


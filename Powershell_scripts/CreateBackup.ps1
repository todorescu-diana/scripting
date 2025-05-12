$sourceFilePath = Read-Host "Enter path of file you want to backup"

if (-not (Test-Path $sourceFilePath)) {
	Write-Output "File can't be found at ${sourceFilePath}. Exiting ..."
	exit
}

$destinationFolderPath = ".\test_folders\backups"

if (-not (Test-Path $destinationFolderPath)) {
	New-Item -ItemType Directory -Path $destinationFolderPath | Out-Null
}

$timestamp = Get-Date -Format "dd_MM_yyy-HH_mm_ss"
$destinationFilePath = "$destinationFolderPath\$(Split-Path -Path $sourceFilePath -Leaf).${timestamp}.bak"

Copy-Item -Path $sourceFilePath -Destination $destinationFilePath

Write-Output "Backup saved at $destinationFilePath"
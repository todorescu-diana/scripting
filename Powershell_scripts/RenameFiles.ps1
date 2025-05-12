$folderPath = Read-Host "Enter foler path"
$suffix = Read-Host "Enter suffix to append"

if (-not (Test-Path $folderPath)) {
	Write-Host "The folder does not exist."
}

$files = Get-ChildItem -Path $folderPath

foreach ($file in $files) {
	$newName = $file.BaseName + $suffix + $file.Extension
	
	Rename-Item -Path $file.FullName -NewName $newName
	Write-Host "Renamed $($file.Name) to $newName"
}
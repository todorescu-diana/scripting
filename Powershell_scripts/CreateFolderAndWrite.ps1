$folderPath = ".\test_folders\ExampleFolder_1"
$filePath = ".\test_folders\ExampleFolder_1\ExampleFile_1.txt"

if (-not (Test-Path -Path $folderPath)) {
	New-Item -ItemType Directory -Path $folderPath
}


"Hello in ExampleFile from Powershell script." | Out-File -FilePath $filePath

Write-Output "ExampleFolder_1 and ExampleFile_1.txt created at $folderPath and $filePath" 
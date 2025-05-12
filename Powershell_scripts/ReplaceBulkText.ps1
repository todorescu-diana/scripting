$folderPath = Read-Host "Enter the folder path containing .txt files"
$searchText = Read-Host "Enter the text to replace"
$replaceText = Read-Host "Enter the text to replace previous text with"

if (-not (Test-Path $folderPath)) {
	Write-Host "Specified folder does not exist."
	exit
}

$files = Get-ChildItem -Path $folderPath -Filter "*.txt"

foreach ($file in $files) {
	$content = Get-Content -Path $file.FullName
	
	$newContent = $content -replace $searchText, $replaceText

	if ($content -ne $newContent) {
		Set-Content -Path $file.FullName -Value $newContent
		Write-Host "Replaced text in file $($file.Name)"
	} else {
		Write-Host "No change needed in file $($file.Name)"
	}
}
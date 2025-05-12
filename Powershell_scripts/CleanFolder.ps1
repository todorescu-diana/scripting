$folderPath = Read-Host "Enter path of folder to clean"

if (-not (Test-Path $folderPath)) {
	Write-Output "Folder does not exist. Exiting ..."
	exit
}

$extensions = Read-Host "Enter extensions to delete (e.g. .log,.tmp)"

$extList = $extensions -split "," | ForEach-Object { $_.Trim() }

$dryRun = Read-Host "Dry run? (Y/N)"
$doDryRun = $dryRun -match "^[Yy]"

$doSkipConfirmation = $true
if(-not $doDryRun) {
	$skipConfirmation = Read-Host "Skip confirmation? (Y/N)"
	$doSkipConfirmation = $skipConfirmation -match "^[Yy]"
}

foreach ($ext in $extList) {
	$files = Get-ChildItem -Path $folderPath -Recurse -Include "*$ext" -File

	foreach($file in $files) {
		if ($doDryRun) {
			Write-Output "[Dry Run] Would delete: $($file.FullName)"
		} else {
			$doConfirm = $true
			if (-not $doSkipConfirmation) {
				$confirm = Read-Host "Delete $($file.FullName)? (Y/N)"
				$doConfirm = $confirm -match "^[Yy]"
			}
			if ((-not $doSkipConfirmation -and $doConfirm -or ($doSkipConfirmation))) {
				Remove-Item $file.FullName -Force
				Write-Output "Deleted $($file.FullName)"
			} else {
				Write-Output "Skipped $($file.FullName)"
			}
		}
	}
}

Write-Output "Cleanup done."
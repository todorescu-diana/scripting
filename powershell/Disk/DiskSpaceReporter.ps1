$drives = Get-WmiObject Win32_LogicalDisk -Filter "DriveType = 3"

foreach ($drive in $drives) {
	$driveLetter = $drive.DeviceID
	$totalSpace = [math]::round($drive.Size / 1GB, 2)
	$freeSpace = [math]::round($drive.FreeSpace / 1GB, 2)
	$usedSpace = $totalSpace - $freeSpace

	Write-Output "Drive ${driveLetter} :"
	Write-Output "	Total Space: $totalSpace GB"
	Write-Output "	Free Space: $freeSpace GB"
	Write-Output "	Used Space: $usedSpace GB"
	Write-Output ""
}
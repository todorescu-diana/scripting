$action = Read-Host "Enter 'L' to show running processes, 'K' to stop a process, or 'I' to inspect a specific process"

if ($action -eq "L") {
	$no = Read-Host "Enter number of processes to list"

	Get-WmiObject -class Win32_PerfFormattedData_PerfProc_Process | 
		Sort-Object workingSetPrivate -Descending | 
		Select-Object -First $no -Property Name, IDProcess, PercentProcessorTime, workingSetPrivate, WorkingSetSize, IODataOperationsPersec, IODataBytesPerSec |
		Format-Table -Property Name, 
					IDProcess, 
					PercentProcessorTime, 
					@{Name="Memory Usage (MB)";Expression={[math]::round($_.workingSetPrivate / 1MB, 2)}}, 
					@{Name="Working Set Size (MB)";Expression={[math]::round($_.WorkingSetSize / 1MB, 2)}}, 
					IODataOperationsPersec, 
					IODataBytesPersec
} elseif ($action -eq "K") {
	$procId = Read-Host "Enter ID of the process to kill"
	try {
		Stop-Process -Id $procId
		Write-Host "Process with ID $procId has been killed."
	} catch {
		Write-Host "Error: Could not kill process with ID $procId. $_"
	}
} elseif ($action -eq "I") {
	$name = Read-Host "Enter name of process to search for"
	Get-WmiObject -class Win32_PerfFormattedData_PerfProc_Process | 
		Where-Object { $_.name -like "*$name*" } |
		Format-Table -Property Name, 
					IDProcess, 
					PercentProcessorTime, 
					@{Name="Memory Usage (MB)";Expression={[math]::round($_.workingSetPrivate / 1MB, 2)}}, 
					@{Name="Working Set Size (MB)";Expression={[math]::round($_.WorkingSetSize / 1MB, 2)}}, 
					IODataOperationsPersec, 
					IODataBytesPersec

} else {
	Write-Host "Invalid option. Valid options: 'L', 'K', 'I'."
}
$outputPath = ".\SystemInfo.txt"

try {
$sysInfo = @{
	"Computer Name" = $env:COMPUTERNAME
	"User Name" = $env:USERNAME
	"Operating System" = (Get-CimInstance Win32_OperatingSystem).Caption
	"OS Version" = (Get-CimInstance Win32_OperatingSystem).Version
	"Architecture" = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
	"System Uptime" = ((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime).ToString("dd\.hh\:mm\:ss")
	"CPU" = (Get-CimInstance Win32_Processor).Name
	"Number of Cores" = (Get-CimInstance Win32_Processor).NumberOfCores
	"Logical Processors" = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
	"RAM (GB)" = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
	"BIOS Version" = (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion
	"Last Boot Time" = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
	"Time Collected" = (Get-Date)
}

$sysInfo.GetEnumerator() | ForEach-Object { "$($_.Key): $($_.Value)" } | Set-Content -Path $outputPath
Write-Host "System info succesfully exported to $outputPath :)" -ForegroundColor Green
} catch {
	Write-Host "Error: $_" -ForegroundColor Red
}
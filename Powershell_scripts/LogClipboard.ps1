Add-Type -AssemblyName PresentationCore

$previous = ""
$logPath = Read-Host "Enter path of log file"

if (![System.IO.Path]::GetExtension($logPath).Equals(".txt")) {
    Write-Host "[Error] File must have a .txt extension. Exiting ..." -ForegroundColor Red
    exit
}

if (-not (Test-Path $logPath)) {
	Write-Host "[Info] Log file does not exist. Creating it ..." -ForegroundColor Cyan
	try {
		New-Item -Path $logPath -ItemType File -Force | Out-Null
		Write-Host "[Info] Log file created at $logPath." -ForegroundColor Cyan
	} catch {
		Write-Host "[Error] Failed to create file. Exiting ..." -ForegroundColor Red
		exit 
	}
}

Write-Host "[Info] Clipboard logging started. Press Ctrl_C to stop." -ForegroundColor Cyan
Write-Host "[Info] Logging to $logPath" -ForegroundColor Cyan

while ($true) {
	try {
		$current = [Windows.Clipboard]::GetText()

		if ($current -and $current -ne $previous) {
			$timestamp = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

			Add-Content -Path $logPath -Value "[$timestamp] $current"
			Write-Host "[Info] New clipbpard content logged at $timestamp"

			$previous = $current
		}

		Start-Sleep -Milliseconds 500
	} catch {
		Start-Sleep -Milliseconds 500
	}
}
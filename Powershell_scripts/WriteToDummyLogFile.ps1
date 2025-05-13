$logPath = ".\test_folders\ExampleFolder_7\DummyLogFile.txt"

if (-not (Test-Path $logPath)) {
	Write-Host "Invalid path. Exiting ..." -ForegroundColor Red
	exit
}

Add-Content -Path $logPath -Value "2025-05-13 14:20:00 Starting process..."
Start-Sleep -Seconds 2

Add-Content -Path $logPath -Value "2025-05-13 14:21:34 CRITICAL: Process failed to start"

Start-Sleep -Seconds 3
Add-Content -Path $logPath -Value "2025-05-13 14:20:00 Starting process..."
Add-Content -Path $logPath -Value "2025-05-13 14:23:56 Process start success"
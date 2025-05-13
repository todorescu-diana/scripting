$logPath = Read-Host "Enter full path to the log file to watch"
$watchedKeywords = @("ERROR", "CRITICAL", "FAILED")

if(-not (Test-Path $logPath)) {
	Write-Host "Log file not found at $logPath. Exiting." -ForegroundColor Red
	exit
}

Write-Host "Watching log: $logPath" -ForegroundColor Cyan
Write-Host "Looking for keywords: $($watchedKeywords -join ', ')" -ForegroundColor Yellow

Get-Content -Path $logPath -Wait -Tail 10 | ForEach-Object {
	foreach ($word in $watchedKeywords) {
		if ($_ -match $word) {
			Write-Host "[!] ALERT: Keyword '$word' found in line:" -ForegroundColor Red
			Write-Host "	$_" -ForegroundColor White
		}
	}
}
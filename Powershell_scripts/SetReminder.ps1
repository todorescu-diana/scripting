$timeInput = Read-Host "Enter reminder time (e.g. 14:30)"
$reminderMsg = Read-Host "Enter your reminder message"
try {
	$reminderTime = Get-Date $timeInput

	if ($reminderTime -lt (Get-Date)) {
		$reminderTime = $reminderTime.AddDays(1)
	}
} catch {
	Write-Host "Invalid time format. Valid format: HH:mm" - ForegroundColor Red
	exit
}

$waitTime = ($reminderTime - (Get-Date)).TotalSeconds
Write-Host "Reminder set for $reminderTime. Waiting..." -ForegroundColor Green
Start-Sleep -Seconds $waitTime

Add-Type -AssemblyName PresentationFramework
[console]::beep(1000, 500)
[System.Windows.MessageBox]::Show($reminderMsg, "Reminder")
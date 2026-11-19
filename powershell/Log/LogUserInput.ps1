$userInput = Read-Host "Hi! :) Enter message to log"
$timestamp = Get-Date -Format "dd.MM.yyyy HH:mm:ss"

$logFilePath = ".\test_folders\ExampleFolder_2\UserLog.txt"

$folder = Split-Path $logFilePath
if (-not (Test-Path $folder)) {
	New-Item -ItemType Directory -Path $folder | Out-Null
}

$logMessage = "User input logged at ${timestamp}: $userInput"
$logMessage | Out-File -FilePath $logFilePath -Append

Write-Output "Message logged to $logFilePath. Bye!"
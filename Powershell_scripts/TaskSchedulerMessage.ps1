$message = "Welcome! :)"

Write-Host $message -ForegroundColor Green
Start-Sleep -Seconds 30

# open task scheduler (taskschd.msc)
# click Create Task
# name it (example Display Startup Message)

# add trigger:
# Option 1: Start the task at logon
# Option 2: On an event -> Log: System; Source: Power-TroubleShooter; Event ID: 1 (system waking up from sleep)

# add new action to Start a program -> powershell.exe -> Add arguments field -> -ExecutionPolicy Bypass -File "<location_of_file>"
$refreshInterval = 2
$no = Read-Host "Enter number of processes to list"

while ($true) {
    Clear-Host
    Write-Host "Top $no processes - Refreshing every $refreshInterval seconds (`Ctrl+C` to stop)" -ForegroundColor Cyan

    Get-WmiObject -class Win32_PerfFormattedData_PerfProc_Process | 
        Sort-Object workingSetPrivate -Descending | 
        Select-Object -First $no -Property Name, IDProcess, PercentProcessorTime, workingSetPrivate, WorkingSetSize, IODataOperationsPersec, IODataBytesPerSec |
        Format-Table -AutoSize -Property Name, 
                    IDProcess, 
                    PercentProcessorTime, 
                    @{Name="Memory Usage (MB)";Expression={[math]::round($_.workingSetPrivate / 1MB, 2)}}, 
                    @{Name="Working Set Size (MB)";Expression={[math]::round($_.WorkingSetSize / 1MB, 2)}}, 
                    IODataOperationsPersec, 
                    IODataBytesPerSec

    Start-Sleep -Seconds $refreshInterval
}

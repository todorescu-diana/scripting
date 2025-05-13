function isValidOctet {
	param ($o)

	return ($o -match '^\d+$' -and [int]$o -ge 0 -and [int]$o -le 255)
}

function validateInput {
	param ($baseIP, $start, $end)

	$parts = $baseIP -split '\.'
	if ($parts.Count -ne 3) {
		return $false
	}
	
	if (($parts | ForEach-Object { isValidOctet $_ }) -contains $false) {
		return $false
	}

	return ((isValidOctet $start) -and (isValidOctet $end) -and [int]$start -ge 1)
}

$baseIP = Read-Host "Enter base IP (first 3 octets - e.g. <o1>.<o2>.<o3>)"
$start = Read-Host "Enter first host number (start value of last octet)"
$end = Read-Host "Enter last host number (end value of last octet)"

$isValidInput = validateInput $baseIP $start $end
if (-not $isValidInput) {
	Write-Host "Invalid input." -ForegroundColor Red
	exit
}

Write-Host "Scanning range $baseIP.$start - $baseIP.$end..." -ForegroundColor Cyan

try {
	$pingSender = New-Object System.Net.NetworkInformation.Ping
	$timeout = 500

	for ($i = [int]$start; $i -le [int]$end; $i++) {
		$ip = "$baseIP.$i"

		$reply = $pingSender.Send($ip, $timeout)
		if ($reply.Status -eq 'Success') {
			try {
			$hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
			} catch {
				$hostname = "(no hostname)"
			}
			Write-Host "ONLINE: $ip" -ForegroundColor Green
		} else {
			Write-Host "Offline: $ip" -ForegroundColor DarkGray
		}
	}
} catch {
	Write-Host "Error: $_ " -ForegroundColor Red
}
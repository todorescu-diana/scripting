$i = Get-Random -Minimum 1 -Maximum 7

Get-Content "ascii_cat_$i.txt" | Out-Host

Write-Host "`n`n[>] Enter number of random cat facts you want:" -ForegroundColor Yellow
$numFacts = Read-Host

$parsedNumber = 0
if (-not [int]::TryParse($numFacts, [ref]$parsedNumber)) {
	Write-Host "[e] Invalid input. Expecting integer number. Goodbye." -ForegroundColor Red
	exit
}

Write-Host "`n =================================================== FACTS: ===================================================" -ForegroundColor Magenta

try {
	$json = Invoke-RestMethod -uri https://catfact.ninja/facts?limit=$numFacts
	$data = $json.data
	$data | % { $idx = 1 } { $fact = $_.fact; "$idx. $fact"; $idx++ }
} catch {
	Write-Host "[e] Error: $_" -ForegroundColor Red
}

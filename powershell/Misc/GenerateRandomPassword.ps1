$length = Read-Host "Enter password length"

$upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
$lower = 'abcdefghijklmnopqrstuvwxyz'
$digits = '0123456789'
$special = '!@#$%^&*()-_=+[]{};:,.<>?'

$allChars = ($upper + $lower + $digits + $special).ToCharArray()

$password = -join ((1..$length) | ForEach-Object {$allChars | Get-Random})

Write-Host "Generated password: $password"
function ConvertFrom-SecureStringToPlainText {
    param ($secureString)
    $marshal = [System.Runtime.InteropServices.Marshal]
    $ptr = $marshal::SecureStringToBSTR($secureString)
    $plainText = $marshal::PtrToStringBSTR($ptr)
    $marshal::ZeroFreeBSTR($ptr)
    return $plainText
}

try {
	Get-Content ascii.txt | Out-Host
	while ($true) {
		Write-Host "1. List users`n2. List users verbose`n3. List users with filter by boolean property`n4. Inspect user`n5. Modify user`n6. Add user`n7. Delete user"
		Write-Host "Select action to perform (e.g. 3; type 'exit' to quit):" -ForegroundColor Yellow
		$action = Read-Host

		if ($action -eq "exit") {
			break
		}

		switch ( $action ) {
			1 {
				Write-Host "[i] Local Users:" -ForegroundColor Cyan
				Get-LocalUser | Out-Host
			}
			2 {
				Write-Host "[i] Local Users (verbose):" -ForegroundColor Cyan
				Get-LocalUser | Select *
			}
			3 {
				$validProperties = Get-LocalUser | Select-Object -First 1 | Get-Member -MemberType Properties
				$validObject = Get-LocalUser | Select-Object -First 1

				$validPropertiesPSObjects = $validObject.psobject.Properties | ForEach-Object {
					$type = if ($_.Value) { $_.Value.GetType().FullName } else {""}
					if ($type -eq "System.Boolean") {
						[PSCustomObject]@{
							Name = $_.Name
							Type = $type
							Value = $_.Value
						}
					}
				}

				$validPropertyNames = ($validPropertiesPSObjects | Select-Object -ExpandProperty Name) -join ", "
				Write-Host "[>] Enter boolean property to filter by (Valid properties: $validPropertyNames):" -ForegroundColor Yellow
				$propertyName = Read-Host

				$prop = $null
				
				foreach ($p in $validPropertiesPSObjects) {
					if ($p.Name -eq $propertyName) {
						$prop = $p
						break
					}
				}

				if (-not $prop) {
					break
				}
				if ($prop.Type -eq "System.Boolean") {
					Write-Host "Property should be true / false:"  -ForegroundColor Yellow
					$booleanVal = Read-Host
					$bool = [System.Convert]::ToBoolean($booleanVal)

					Write-Host "[i] Filtered Users:" -ForegroundColor Cyan
					
					if (($booleanVal -eq "true") -or ($booleanVal -eq "false")) {
						Get-LocalUser | Select * | Where-Object {$_.$($prop.Name) -eq $bool}
					}
				}
			}
			4 {
				Write-Host "[>] Enter username:" -ForegroundColor Yellow
				$userName = Read-Host

				Write-Host "[i] User <$userName> details:" -ForegroundColor Cyan
				Get-LocalUser -Name $userName | Select *
			}
			5 {
				Write-Host "[>] Enter username of user to modify:" -ForegroundColor Yellow
				$userName = Read-Host

				$checkForUser = (Get-LocalUser).Name -Contains $userName
				if ($checkForUser -eq $false) {
					Write-Host "Local user <$userName> does not exist." -ForegroundColor Red
					break
				}

				Write-Host "[i] User <$userName> details:" -ForegroundColor Cyan

				$user = Get-LocalUser -Name $userName
				$user | Select *

				$validProperties = @("Name", "FullName", "Description", "Password", "AccountExpires")
				$validPropertiesStr = $validProperties -join ', '
			
				Write-Host "[>] Enter property to modify (Valid properties: $validPropertiesStr)" -ForegroundColor Yellow
				$property = Read-Host

				if (!($validProperties -contains $property)) {
					Write-Host "Property not valid." -ForegroundColor Red
					break
				}

				Write-Host "[i] Current property value:" -ForegroundColor Cyan
				$user.$property

				switch ($property) {
					$validProperties[0] {
						try {
							Write-Host "[>] Enter new $property value:" -ForegroundColor Yellow
							$newVal = Read-Host

							$params = @{
								Name = $userName
								NewName = $newVal
							}

							Rename-LocalUser @params
							Write-Host "[i] Succesfully modified user <$userName>." -ForegroundColor Cyan
						} catch {
							Write-Host "[!] Error: $_" -ForegroundColor Red
						}
					}
					{($_ -eq $validProperties[1]) -or ($_ -eq $validProperties[2])} {
						try {
							Write-Host "[>] Enter new $property value:" -ForegroundColor Yellow
							$newVal = Read-Host

							$params = @{
								Name = $userName
							}
							$params[$property] = $newVal

							Set-LocalUser @params
							Write-Host "[i] Succesfully modified user <$userName>." -ForegroundColor Cyan
						} catch {
							Write-Host "[!] Error: $_" -ForegroundColor Red
						}
					}
					$validProperties[3] {
						try {
							Write-Host "[>] Enter new $property value:" -ForegroundColor Yellow
							$newPassword = Read-Host -AsSecureString

							Write-Host "[>] Re-enter new $property value:" -ForegroundColor Yellow
							$newPasswordCheck = Read-Host -AsSecureString

							$plain1 = ConvertFrom-SecureStringToPlainText $newPassword
							$plain2 = ConvertFrom-SecureStringToPlainText $newPasswordCheck

							if ($plain1 -eq $plain2) {
								$user | Set-LocalUser -Password $newPassword
								Write-Host "[i] Succesfully modified user <$userName>." -ForegroundColor Cyan
							} else {
								Write-Host "Passwords don't match." -ForegroundColor Red
							}
						} catch {
							Write-Host "[!] Error: $_" -ForegroundColor Red
						}
					}
					$validProperties[4] {
						try {
							Write-Host "[>] Enter new account expiry date (yyyy-mm-dd):" -ForegroundColor Yellow
							$userInputExpiryDate = Read-Host
							$newExpiryDate = Get-Date $userInputExpiryDate

							$user | Set-LocalUser -AccountExpires $newExpiryDate
							Write-Host "[i] Succesfully modified user <$userName>." -ForegroundColor Cyan
						} catch {
							Write-Host "[!] Error: $_" -ForegroundColor Red
						}
					}
					default {
						Write-Host "Invalid input."
					}
				}
			}
			6 {
				Write-Host "[>] Enter new user's username:" -ForegroundColor Yellow
				$newUserName = Read-Host

				Write-Host "[>] Enter new user's description:" -ForegroundColor Yellow
				$newUserDescription = Read-Host

				Write-Host "[>] Enter new user's full name:" -ForegroundColor Yellow
				$newUserFullName = Read-Host

				Write-Host "Should the new account have a password?: (yes / no)" -ForegroundColor Yellow
				$shouldHavePass = Read-Host
				
				if ($shouldHavePass -eq "yes") {
					Write-Host "[>] Enter new user's password:" -ForegroundColor Yellow
					$newUserPassword = Read-Host -AsSecureString
				}

				Write-Host "Should the new account expire?: (yes / no)" -ForegroundColor Yellow
				$shouldExpire = Read-Host
				
				if ($shouldExpire -eq "yes") {
					Write-Host "[>] Enter expiry date (Format: DD-MM-YYYY):" -ForegroundColor Yellow
					$newExpiryDateStr = Read-Host

					try {
						$newExpiryDateTime = [datetime]::ParseExact($newExpiryDateStr, 'dd-MM-yyyy', $null)
					} catch {
						Write-Host "[!] Date error: $_"
					}
				}

				Write-Host "Should the new account be enabled?: (yes / no)" -ForegroundColor Yellow
				$shouldBeEnabled = Read-Host

				Write-Host "[?] Create new local user? (yes / no):"
				$ans = Read-Host

				if ($ans -eq "yes") {
					try {
						$params = @{
							Name = $newUserName
							FullName = $newUserFullName
							Description = $newUserDescription
						}

						if ($shouldHavePass -eq "yes") {
							$params["Password"] = $newUserPassword
						} else {
							$params["NoPassword"] = $true
						}

						if ($shouldExpire -eq "yes") {
							$params["AccountExpires"] = $newExpiryDateStr
						} else {
							$params["AccountNeverExpires"] = $true
						}

						if ($shouldBeEnabled -eq "no") {
							$params["Disabled"] = $true
						}

						New-LocalUser @params

						Write-Host "[i] New local user <$newUserName> successfully created" -ForegroundColor Cyan
					} catch {
						Write-Host "[!] Error: $_" -ForegroundColor Red
					}
				}
			}
			7 {
				Write-Host "[>] Enter username of local user account to delete:" -ForegroundColor Yellow
				$userNameToDelete = Read-Host

				Write-Host "Delete user <$userNameToDelete>?: (yes / no)" -ForegroundColor Yellow
				$del = Read-Host

				if ($del -eq "yes") {
					try {
						Remove-LocalUser -Name $userNameToDelete

						Write-Host "[i]Successfully deleted local user <$userNameToDelete>" -ForegroundColor Cyan
					} catch {
						Write-Host "[!] Error: $_" -ForegroundColor Red
					}
				}
			}
			default {
				Write-Host "Invalid input."
			}
		}
	}
	
} catch {
	Write-Host "[error $_] Quitting ..." -ForegroundColor Red
	exit
} finally {
	Write-Host "`nBye :)" -ForegroundColor Yellow
}

$Days = 30
$Time = [DateTime]::Today.AddDays(-$Days)
Get-ADUser -Filter {(mail -like "*@nara.gov*") -and (Enabled -eq $true) -and (PasswordLastSet -lt $Time)} -Properties Mail,PasswordLastSet |
Select GivenName,SurName,Mail,PasswordLastSet |
Export-csv -path C:\temp\HeresyUsers\PW_Changed.csv -NoTypeInformation
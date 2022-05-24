Connect-MsolService
#Create csv file with columns named: DisplayName; FirstName; LastName; UserPrincipalName; UsageLocation; AccountSkuId; Password
#Retrieve SkuID from Connect-MsolService and run Get-MsolAccountSku
#Must include Usage Location for License to be applied
Import-Csv -Path C:\365_PS_Files\NewUsers.csv | foreach {New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName -UsageLocation $_.UsageLocation -LicenseAssignment $_.AccountSkuId -Password $_.Password} | Export-Csv -Path C:\Scripts\NewAccountResults.csv
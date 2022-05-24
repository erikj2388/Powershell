$Days = ([math]::Ceiling((([DateTime]'01-01-2021')-(Get-Date)).TotalDays))
$Time = [DateTime]::Today.AddDays(-$Days)

Get-ADComputer -filter {(Enabled -eq $true) -and (LastLogonDate -lt $Time)} -Properties LastLogonDate,DistinguishedName,DNSHostName |
Select DNSHostName,LastLogonDate,DistinguishedName |
Export-csv -path C:\temp\HeresyUsers\Reconciled_PCs.csv -NoTypeInformation
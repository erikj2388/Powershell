#Put in 365 admin account name below
$Cred = Get-credential #admin@365domain.com
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
#To create multiple at once, save a csv file named SharedMailboxes with columns for Name; DisplayName, and PrimarySMTPAddress
#Point to the path of the csv file to import it
Import-csv -Path C:\365_PS_Files\SharedMailboxes.csv | foreach { New-Mailbox -Shared -Name $_.Name -DisplayName $_.DisplayName -PrimarySMTPAddress $_.PrimarySMTPAddress}
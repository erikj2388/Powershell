#List the name of the admin account being used for 365 access.
$Cred = Get-credential #admin@365.com
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
#Create a csv file with 2 Columns. One named User and one named Mailbox. List the name of the User being added under User and the corresponding mailbox they need access to
#Import the file by pointing to the path you have the csv file saved
Import-Csv  C:\365_PS_Files\Permissions.csv | foreach { Add-MailboxPermission  $_.Mailbox  -User  $_.User  -AccessRights  FullAccess }
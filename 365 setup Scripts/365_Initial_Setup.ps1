#Create new O365 user accounts
Connect-MsolService
#Create csv file with columns named: DisplayName; FirstName; LastName; UserPrincipalName; UsageLocation; AccountSkuId; Password
#Retrieve SkuID from Connect-MsolService and run Get-MsolAccountSku
#Must include Usage Location for License to be applied
Import-Csv -Path C:\365_PS_Files\NewUsers.csv | foreach {New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName -UsageLocation $_.UsageLocation -LicenseAssignment $_.AccountSkuId -Password $_.Password}


#Create new shared mailboxes
$Cred = Get-credential #admin@365domain.com
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
#To create multiple at once, save a csv file named SharedMailboxes with columns for Name; DisplayName, and PrimarySMTPAddress
#Point to the path of the csv file to import it
Import-csv -Path C:\365_PS_Files\SharedMailboxes.csv | foreach { New-Mailbox -Shared -Name $_.Name -DisplayName $_.DisplayName -PrimarySMTPAddress $_.PrimarySMTPAddress}

#Create Distribution Groups
#Create csv named DistroGroups with column for each variable. Can then run sepearate script to add members to each one afterwards.
Import-csv C:\365_PS_Files\DistroGroups.csv | foreach {New-DistributionGroup -Name $_.Name -Type $_.Distro -PrimarySmtpAddress $_.PrimarySmtpAddress -ManagedBy $_.Manager}

#Add members to Distribution groups
#Create csv with two columns: Distro and User, where Distro is the name or smtpaddress for the Distribution Group and User is the name or smtpaddress user being added
#Need to include Distro for each user
Import-Csv  C:\365_PS_Files\NewMembers.csv | foreach { Add-DistributionGroupMember -Identity $_.Distro -Member $_.User }

#Add Full Access to mailboxes/shared mailboxes
#Create a csv file with 2 Columns: User and Mailbox. List the name of the User being added under User and the corresponding mailbox they need access to
#Import the file by pointing to the path you have the csv file saved
Import-Csv  C:\365_PS_Files\Permissions.csv | foreach { Add-MailboxPermission  $_.Mailbox  -User  $_.User  -AccessRights  FullAccess }
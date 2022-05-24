#Add the admin account for the 365 tenant
$Cred = Get-credential #admin@O365.domain
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Create csv named DistroGroups with column for each variable. Can then run sepearate script to add members to each one afterwards.
Import-csv C:\365_PS_Files\DistroGroups.csv | foreach {New-DistributionGroup -Name $_.Name -Type $_.Distro -PrimarySmtpAddress $_.PrimarySmtpAddress -ManagedBy $_.Manager}


#Type in the name of the Distro, Type in the smtp address, type in address of managing or admin account, add members with a comma seperating them
#Members: user1@email.com,user2@email.com
#New-DistributionGroup -Name "Name of Distro" -Type "Distribution" -PrimarySmtpAddress ***EmailAddress*** -ManagedBy ***AddManaging Address*** -Members ***add mailboxes seperated by ,***

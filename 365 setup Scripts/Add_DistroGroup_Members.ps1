#List the name of the admin account being used for 365 access.
$Cred = Get-credential #admin@365.com
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
#Create csv with two columns: Distro and User, where Distro is the name for the DIstribution Group and User is the user being added
#Need to include Distro for each user
Import-Csv  C:\365_PS_Files\NewMembers.csv | foreach { Add-DistributionGroupMember -Identity $_.Distro -User $_.User }
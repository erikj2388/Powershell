Import-Module ActiveDirectory

Get-aduser -filter * -Properties cn, givenName, Initials, sn, mail, LastLogonTimestamp, WhenCreated, title, userAccountControl |
Where-Object {($_.DistinguishedName -notlike "*Heresy*") -and ($_.DistinguishedName -notlike "*OU=Enterprise,DC=win,DC=nara,DC=gov")} |
select cn, givenName, sn, Initials, mail, title, @{Name="LastLogon";Expression={([datetime]::FromFileTime($_.LastLogonTimestamp))}}, WhenCreated, userAccountControl |
Export-csv -Path c:\temp\NARA_User_Info.csv -NoTypeInformation
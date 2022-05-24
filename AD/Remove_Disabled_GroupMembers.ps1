Import-Module ActiveDirectory

$groupName = "SG_DoNotDisable"
$groupMembers = (Get-ADGroupMember -Identity $groupName)

Foreach ($member in $groupMembers){
    If ((Get-ADUser -Identity $member).enabled -eq $false){
        #Remove-ADGroupMember -Identity $groupName -Members $member -Whatif
        Get-ADUser $member | Select samaccountName,Enabled
        }
    }
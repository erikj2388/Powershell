import-module activedirectory
$ldapusers = Get-ADObject -Credential (Get-Credential) -Server na2-mimldap-01:1389 -SearchBase 'ou=users,o=nara' -Properties pwdlastset -LDAPFilter "objectclass=user" | Select Name,@{Name="PWsetDate";Expression={[datetime]::FromFileTime($_."pwdlastset")}} 

$row = "Name" +"," + "Enabled" + "," + "LDAP PWDLastSet" + "," + "AD PWLastSet" + "," + "Synced"
$filePath = "C:\temp\LDAP_PW_Synced\PW_Not_Synced_Enabled.csv"
Out-File -FilePath $filePath -InputObject $row

foreach ($ldapuser in $ldapusers) {
    $aduserprop = Get-ADUser $ldapuser.name -Properties LastLogonDate,Enabled,passwordlastset,passwordneverexpires,SmartcardLogonRequired,msDS-UserPasswordExpiryTimeComputed -ErrorAction SilentlyContinue -ErrorVariable Err
    if (-Not $Err) {
        if ($aduserprop.PasswordLastSet) {
            $synced = $aduserprop.passwordlastset.tostring("MM-dd-yyyy") -eq $ldapuser.PWsetDate.tostring("MM-dd-yyyy")

        }
        else {
            $synced = $False
        }

       if (($synced -eq $False) -and ($aduserprop.Enabled -eq $True)){

            $usersinfo = $ldapuser.Name + "," + $aduserprop.Enabled + "," + $ldapuser.PWsetDate + "," + $aduserprop.passwordlastset + "," + $synced
            Out-File -FilePath $filePath -InputObject $usersinfo -Append
        }

}
}

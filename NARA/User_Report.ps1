$ldapusers = Get-ADObject -Server na2-mimldap-01:1389 -SearchBase 'ou=users,o=nara' -Properties cn, givenName, sn, Initials, mail, Title, department, LastLogonTimeStamp, WhenCreated -LDAPFilter "objectclass=user" | select cn, givenName, sn, Initials, mail, Title, department, @{Name="LastLogon";Expression={[datetime]::FromFileTime($_.LastLogonTimeStamp)}}, WhenCreated

$row = "UserName" + "," + "First Name" + "," + "LastName" + "," + "Initials" + "," + "EMail" + "," + "Title" + "," + "Department" + "," + "LastLogonTime" + "," + "WhenCreated" + "," + "UserAccountControl"
$filepath = "C:\temp\NARA_User_Info.csv"
Out-File -FilePath $filepath -InputObject $row

foreach ($ldapuser in $ldapusers) {
    $aduserprop = Get-ADUser $ldapuser.cn -Properties userAccountControl -ErrorAction SilentlyContinue -ErrorVariable Err

    $userinfo = $ldapuser.cn + "," + $ldapuser.givenName + "," + $ldapuser.sn + "," + $ldapuser.Initials + "," + $ldapuser.mail + "," + $ldapuser.Title + "," + $ldapuser.department + "," + $ldapuser.LastLogon.tostring() + "," + $ldapuser.WhenCreated + "," + $aduserprop.UserAccountControl

    Out-File -FilePath $filepath -InputObject $userinfo -Append
}
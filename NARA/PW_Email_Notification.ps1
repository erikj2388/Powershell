import-module activedirectory

#Pulls the Password Last Set attribute from all user accounts in NARAELDAP
$ldapusers = Get-ADObject -Credential (Get-Credential) -Server na2-mimldap-01:1389 -SearchBase 'ou=users,o=nara' -Properties pwdlastset -LDAPFilter "objectclass=user" | Select Name,@{Name="PWsetDate";Expression={[datetime]::FromFileTime($_."pwdlastset")}} 



foreach ($ldapuser in $ldapusers) {
    $aduserprop = Get-ADUser $ldapuser.name -Properties GivenName,EmailAddress,Enabled,passwordlastset,msDS-UserPasswordExpiryTimeComputed -ErrorAction SilentlyContinue -ErrorVariable Err
    if (-Not $Err) {
        if ($aduserprop.PasswordLastSet) {
            #Compares Password Last Set dates between LDAP and AD
            $synced = $aduserprop.passwordlastset.tostring("MM-dd-yyyy") -eq $ldapuser.PWsetDate.tostring("MM-dd-yyyy")

        }
        else {
            $synced = $False
        }

       if (($synced -eq $False) -and ($aduserprop.Enabled -eq $True)){

             #Sends out the email notification for the user to reset their password if the password isn't synced to NARAELDAP
              $Email = $aduserprop.EmailAddress
              $Name = $aduserprop.GivenName
 
              $EmailSubject="Password Expiry Notice - your password expires on February 3, 2020"
              $Message="
              Dear $Name,
              <p> Your Password expires on 2/3/2022.<br />
              To change your password, Please go to https://pss.archives.gov and reset your password. <br />



            <p>If you do not update your password by this date, you will not be able to log in, so please make sure you update your password. <br /></p>



            <p>If you require assistance, please contact NARA IT Call Center at 703-872-7755 or ITSupport@nara.gov. <br /></p>



            Sincerely, <br />
              NARA Information Technology and Telecommunications Support Services (NITTSS) Support Team <br />
              </p>"



            #Variables to be passed for sending the message
            $smtp = "smtp.nara.gov" 
 
            $to = "$Email" 
 
            $from = "notification@nara.gov" 
 
            $subject = "$EmailSubject"  
 
            $body = "$Message" 
  
 
#### Now send the email using \> Send-MailMessage  
 
 send-MailMessage -SmtpServer $smtp -To $to -From $from -Subject $subject -Body $body -BodyAsHtml
        }

}
}
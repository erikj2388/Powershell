# Variables for Svc account in Prod
$TenantAdJoinAcct= "svc-forge-adjoin"
$UPN= $TenantAdJoinAcct + "@c2.5g.prod.army.mil"
$TenantSvcAcctPath= "OU=DomainJoin,OU=ServiceAccounts,OU=UserAccounts,OU=c2,OU=5g,OU=prod,DC=army,DC=mil"

# Create Tenant Svc account in Prod
New-ADUser -Name $TenantAdJoinAcct -GivenName $TenantAdJoinAcct -SamAccountName $TenantAdJoinAcct -DisplayName $TenantAdJoinAcct -UserPrincipalName $UPN -Path $TenantSvcAcctPath -AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true

#Variables for new OUs
Get-Content -Path c:\scripts\TenantOU.txt | Foreach-Object {
$TenantOUPath= 'OU=Tenants,OU=Enclave,OU=c2,OU=5g,OU=prod,DC=army,DC=mil'
$AllOUs = ''
$OUs = (Split-Path $_ -Parent).Split('\')
#The array reverse isn't necessary currently
#[array]::Reverse($OUs)
$OUs | Foreach-Object {
 if ($_.Length -eq 0) {
     return
 }
 $AllOUs = $AllOUs + 'OU=' + $_ + ','
 }
 $AllOUs += $TenantOUPath
 $NewOUName = Split-Path $_ -Leaf

 #Created the new OUs
 New-ADOrganizationalUnit -Name "$NewOUName" -Path "$AllOUs" -ProtectedFromAccidentalDeletion $false

 #Set variables for assigning ACL Permisions
 $OU_DN = 'OU=' + $NewOUName + ',' + $AllOUs
 $acl = get-acl AD:$OU_DN
 $SVC_ACCT = Get-ADUser $TenantAdJoinAcct
 $sid = new-object System.Security.Principal.SecurityIdentifier $SVC_ACCT.SID

 #Setting the Access Rules for the SVC Account
 #Create Computer Objects - This Object and Descendant Objects
 $acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $sid, "CreateChild","Allow",([GUID]("bf967a86-0de6-11d0-a285-00aa003049e2")).guid,"All",([GUID]("00000000-0000-0000-0000-000000000000")).guid))

 #Validate write to service principle name - Descendant Computer Objects
 $acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $sid, "Self","Allow",([GUID]("f3a64788-5306-11d1-a9c5-0000f80367c1")).guid,"Descendents",([GUID]("bf967a86-0de6-11d0-a285-00aa003049e2")).guid))
 
 #Read\Write Account Restrictions - Descendant Computer Objects
 $acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $sid, "ReadProperty, WriteProperty","Allow",([GUID]("4c164200-20c0-11d0-a768-00aa006e0529")).guid,"Descendents",([GUID]("bf967a86-0de6-11d0-a285-00aa003049e2")).guid))
 
 #Validate Write to DNS - Descendant Computer Objects
 $acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $sid, "Self","Allow",([GUID]("72e39547-7b18-11d1-adef-00c04fd8d5cd")).guid,"Descendents",([GUID]("bf967a86-0de6-11d0-a285-00aa003049e2")).guid))
 
 #Reset Password - Descendant Computer Objects
 $acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $sid, "ExtendedRight","Allow",([GUID]("00299570-246d-11d0-a768-00aa006e0529")).guid,"Descendents",([GUID]("bf967a86-0de6-11d0-a285-00aa003049e2")).guid))
 
 #Applies new Access Rules to OUs
 Set-acl AD:$OU_DN -aclobject $acl

 }
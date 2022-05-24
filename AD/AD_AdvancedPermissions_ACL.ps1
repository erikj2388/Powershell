Import-Module ActiveDirectory

$OU_DN = "OU=NewOU,DC=WinLab,DC=Local"

$acl = get-acl AD:$OU_DN

$SVC_ACCT = Get-ADUser "Test1"

$sid = new-object System.Security.Principal.SecurityIdentifier $SVC_ACCT.SID

$AcctRsct_GUID = new-object Guid  4c164200-20c0-11d0-a768-00aa006e0529 # is the rightsGuid for the Read/Write Account Restrictions

$inheritedobjectguid = new-object Guid  bf967a86-0de6-11d0-a285-00aa003049e2 # inherited Objecttype in access list. Computer Object GUID

$identity = [System.Security.Principal.IdentityReference] $SID

$AcctRsctRights = [System.DirectoryServices.ActiveDirectoryRights] "ReadProperty, WriteProperty"

$type = [System.Security.AccessControl.AccessControlType] "Allow"

$inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "Descendents"

$ace = new-object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$AcctRsctRights,$type,$AcctRsct_GUID,$inheritanceType,$inheritedobjectguid

$acl.AddAccessRule($ace)

Set-acl AD:$OU_DN -aclobject $acl
<#
This post lists out common GUID values to help
https://social.technet.microsoft.com/Forums/azure/en-US/df3bfd33-c070-4a9c-be98-c4da6e591a0a/forum-faq-using-powershell-to-assign-permissions-on-active-directory-objects?forum=winserverpowershell
#>

Import-Module ActiveDirectory

$OU_DN = "OU=NewOU2,DC=winlab,DC=local"

$acl = get-acl AD:$OU_DN

$SVC_ACCT = Get-ADUser "Test2"

$sid = new-object System.Security.Principal.SecurityIdentifier $SVC_ACCT.SID

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

Set-acl AD:$OU_DN -aclobject $acl
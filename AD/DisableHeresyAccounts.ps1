Import-Module ActiveDirectory

Get-ADUser -SearchBase "OU=Heresy,OU=Enterprise,DC=win,DC=nara,DC=gov" -Filter "Enabled -eq 'True'" | Disable-ADAccount
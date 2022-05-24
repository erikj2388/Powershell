$VpnName = 'HLS_VPN'
$gateway = 'VPN.HylandLevin.com'
write-host "$vpnname " -f yellow -NoNewline ; write-host "is the name of the connection and gateway" -NoNewline ; write-host " $gateway." -f Yellow   
$psk = 'HylandLevin6000Sagemore'
$regp = 'HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent' #if VPN server is behind NAT, otherwise comment out this line.   
   
#add l2tp vpn   
Add-VpnConnection -Name $VpnName -ServerAddress $gateway -TunnelType L2tp -AuthenticationMethod PAP -EncryptionLevel Optional -L2tpPsk $psk -Force `  
-AllUserConnection -UseWinLogonCredential $false -SplitTunneling $True
  
Write-Host "Connection has been added." -f Green   
  
#add registry value, if VPN server is behind NAT. Otherwise comment out this line.   
New-ItemProperty -Path $regp -Name AssumeUDPEncapsulationContextOnSendRule -Value 2 -PropertyType 'DWORD' -Force
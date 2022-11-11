<#
Powershell script for creating new NSGs with the baseline rules.
This does not include the Deny rules 4095 and 4096.

Connect using Az-Connect. Verify subscription with Get-AzContext. Use Set AZ-Context -id "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx" to set your context to the desired subscription
#>

$hostVM =  #IP Address of the VM

$nsgName =  #Name of the new NSG

$bastionSubnet = #IP range of Bastion Subnet

$rgName =  #Name of the Resource Group

$location = "EastUS" #Location being deployed to

$rule100 = New-AzNetworkSecurityRuleConfig -Name "AD-Ports-Inbound" `
    -Access Allow -Protocol * -Direction Inbound -Priority 100 -SourceAddressPrefix `
    10.21.70.4,10.21.70.5 -SourcePortRange * -DestinationAddressPrefix  $hostVM -DestinationPortRange 135,137,445

$rule101 = New-AzNetworkSecurityRuleConfig -Name "AD-Ports-Outbound" `
    -Access Allow -Protocol * -Direction Outbound -Priority 101 -SourceAddressPrefix `
    $hostVM -SourcePortRange * -DestinationAddressPrefix 10.21.70.4,10.21.70.5 -DestinationPortRange 53,88,123,135,389,445,464,636,3268,3269,49152-65535

$rule110 = New-AzNetworkSecurityRuleConfig -Name "HTTP-HTTPS-Internet" `
    -Access Allow -Protocol Tcp -Direction Outbound -Priority 110 -SourceAddressPrefix `
    $hostVM -SourcePortRange * -DestinationAddressPrefix Internet -DestinationPortRange 80,443

$rule120 = New-AzNetworkSecurityRuleConfig -Name "Secret-Server-Inbound" `
    -Access Allow -Protocol * -Direction Inbound -Priority 120 -SourceAddressPrefix `
    10.21.72.29 -SourcePortRange * -DestinationAddressPrefix $hostVM -DestinationPortRange 443,8834

$rule130 = New-AzNetworkSecurityRuleConfig -Name "Nessus-Scanner-Inbound" `
    -Access Allow -Protocol Tcp -Direction Outbound -Priority 130 -SourceAddressPrefix `
    10.21.72.28 -SourcePortRange * -DestinationAddressPrefix $hostVM -DestinationPortRange 80,443

$rule140 = New-AzNetworkSecurityRuleConfig -Name "Nessus-Scanner-Outbound" `
    -Access Allow -Protocol Tcp -Direction Outbound -Priority 140 -SourceAddressPrefix `
    $hostVM -SourcePortRange * -DestinationAddressPrefix 10.21.72.28 -DestinationPortRange 8834

$rule150 = New-AzNetworkSecurityRuleConfig -Name "Chocolatey-Inbound" `
    -Access Allow -Protocol * -Direction Inbound -Priority 150 -SourceAddressPrefix `
    10.21.72.14 -SourcePortRange * -DestinationAddressPrefix $hostVM -DestinationPortRange 8443,443,24020,5985

$rule160 = New-AzNetworkSecurityRuleConfig -Name "Bastion-Ports-Inbound" `
    -Access Allow -Protocol * -Direction Inbound -Priority 160 -SourceAddressPrefix `
    $bastionSubnet -SourcePortRange * -DestinationAddressPrefix $hostVM -DestinationPortRange 3389,22

$rule170 = New-AzNetworkSecurityRuleConfig -Name "Chocolatey-Outbound" `
    -Access Allow -Protocol Tcp -Direction Outbound -Priority 170 -SourceAddressPrefix `
    $hostVM -SourcePortRange * -DestinationAddressPrefix 10.21.72.14 -DestinationPortRange 443

New-AzNetworkSecurityGroup -ResourceGroupName $rgName -Location $location -Name `
    $nsgName -SecurityRules $rule100,$rule101,$rule110,$rule120,$rule130,$rule140,$rule150,$rule170

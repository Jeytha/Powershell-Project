<#
Configure-Firewall.ps1
Configures Windows Firewall rules for the Wonderville network baseline.
#>

#region Parameters / Config - EDIT for your environment
$InternalSubnet = "192.168.90.0/24"   # internal LAN subnet - change to your network
$AllowRDPFromInternalName = "Allow RDP from Internal"
$AllowSMBName = "Allow SMB"
$AllowDNSName = "Allow DNS"
$AllowWebName = "Allow Web Traffic"
$BlockRDPExternalName = "Block RDP from External"
#endregion

Write-Output "=== Configuring Windows Firewall for Wonderville IT ==="

try {
    # 1. Enable firewall for all profiles
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

    # 2. Cleanup previous rules (if present)
    Get-NetFirewallRule -DisplayName $AllowRDPFromInternalName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false -ErrorAction SilentlyContinue
    Get-NetFirewallRule -DisplayName $AllowSMBName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false -ErrorAction SilentlyContinue
    Get-NetFirewallRule -DisplayName $AllowDNSName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false -ErrorAction SilentlyContinue
    Get-NetFirewallRule -DisplayName $AllowWebName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false -ErrorAction SilentlyContinue
    Get-NetFirewallRule -DisplayName $BlockRDPExternalName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -Confirm:$false -ErrorAction SilentlyContinue

    # 3. Allow RDP only from internal subnet
    New-NetFirewallRule -DisplayName $AllowRDPFromInternalName `
        -Direction Inbound -Protocol TCP -LocalPort 3389 `
        -RemoteAddress $InternalSubnet -Action Allow -Profile Domain,Private

    # 4. Allow SMB (file sharing) inside the network (TCP 445)
    New-NetFirewallRule -DisplayName $AllowSMBName `
        -Direction Inbound -Protocol TCP -LocalPort 445 `
        -RemoteAddress $InternalSubnet -Action Allow -Profile Domain,Private

    # 5. Allow DNS lookups (outbound UDP 53)
    New-NetFirewallRule -DisplayName $AllowDNSName `
        -Direction Outbound -Protocol UDP -LocalPort 53 -Action Allow -Profile Domain,Public,Private

    # 6. Allow HTTP (80) and HTTPS (443) outbound
    New-NetFirewallRule -DisplayName $AllowWebName `
        -Direction Outbound -Protocol TCP -LocalPort 80,443 -Action Allow -Profile Domain,Public,Private

    # 7. Block RDP from anywhere outside internal subnet
    New-NetFirewallRule -DisplayName $BlockRDPExternalName `
        -Direction Inbound -Protocol TCP -LocalPort 3389 `
        -RemoteAddress Any -Action Block -Profile Domain,Public,Private

    # 8. Enable firewall logging
    Set-NetFirewallProfile -Profile Domain,Public,Private `
        -LogAllowed $true -LogBlocked $true `
        -LogFileName "C:\Windows\System32\LogFiles\Firewall\pfirewall.log" `
        -LogMaxSizeKilobytes 32767

    Write-Output "=== Firewall rules configured successfully! ==="
}
catch {
    Write-Error "Failed to configure firewall: $($_.Exception.Message)"
}

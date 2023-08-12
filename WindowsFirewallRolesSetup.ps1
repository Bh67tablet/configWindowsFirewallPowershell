###
# ----------------------
#
# Bernd Hohmann - bh67
#
# 1. Block all
# 2. Save all Firewall Rules
# 3. Remove all Firewall Rules
# 4. Add Core Rules DNS, DHCP, NTP, http, https
# 5. Add your Rules you need like Teamviewer, RDP, ...
#
# ----------------------
#
# https://de.wikipedia.org/wiki/Liste_der_standardisierten_Ports
#
#
$destDir = "c:\AutoSecure\log"
#
If (!(Test-Path $destDir)) {
   New-Item -Path $destDir -ItemType Directory
}
#
$datum = "$(get-date -f yyyy_MM_dd__hh_mm_ss)"
#
Start-Transcript -Path "$destDir\$datum-firewall-log.txt"
#
$adapter = (Get-NetAdapter -Physical).Name
#
#
# Set-NetFirewallProfile Allow only outbound Action
#
Set-NetFirewallProfile -Name Domain -Enabled True -DefaultInboundAction Block -DefaultOutboundAction Block
Set-NetFirewallProfile -Name Private -Enabled True -DefaultInboundAction Block -DefaultOutboundAction Block
Set-NetFirewallProfile -Name Public -Enabled True -DefaultInboundAction Block -DefaultOutboundAction Block
#
#
get-netfirewallprofile
# Firewall Status
#
Get-NetFirewallRule |
Format-Table -Property DisplayName,
@{Name='Protocol';Expression={($PSItem | Get-NetFirewallPortFilter).Protocol}},
@{Name='RemotePort';Expression={($PSItem | Get-NetFirewallPortFilter).RemotePort}},
Enabled,
Profile,
Direction,
Action
#
#
# Delete all existing Firewall Rules:
#
Get-NetFirewallRule | Remove-NetFirewallRule
#
#
# TCP & UDP - Outgoing - DNS 53, DHCP 67 68 , http 80 , https 443, NTP (Network Time Protokoll) 123, DHCP-Failover 647:
#
New-NetFirewallRule -DisplayName Core_TCP_out -name Core_TCP_out -RemotePort 53, 67, 68, 80, 443, 123, 647, 847, 853, 953, 8953 -Enabled True -Direction Outbound -Action Allow -Protocol TCP -ErrorAction Continue -Group Bernd
#
New-NetFirewallRule -DisplayName Core_UDP_out -name Core_UDP_out -RemotePort 53, 67, 68, 69, 123, 953, 5353 -Enabled True -Direction Outbound -Action Allow -Protocol UDP -ErrorAction Continue -Group Bernd
#
#
# TV (TeamViewer 5938), RDP (Microsoft Remote Desktop 3389), PostgreSQL:
#
New-NetFirewallRule -DisplayName My_TCP_out -name My_TCP_out -RemotePort 5938, 3389, 5432 -Enabled True -Direction Outbound -Action Allow -Protocol TCP -ErrorAction Continue -Group Bernd
#
#New-NetFirewallRule -DisplayName My_TCP_in -name My_TCP_in -RemotePort 5938, 3389 -Enabled True -Direction Inbound -Action Allow -Protocol TCP -ErrorAction Continue -Group Bernd
#
New-NetFirewallRule -DisplayName My_UDP_out -name My_UDP_out -RemotePort 123, 5938, 3389, 5432 -Enabled True -Direction Outbound -Action Allow -Protocol UDP -ErrorAction Continue -Group Bernd
#
#New-NetFirewallRule -DisplayName My_UDP_in -name My_UDP_in -RemotePort 5938, 3389 -Enabled True -Direction Inbound -Action Allow -Protocol UDP -ErrorAction Continue -Group Bernd
#
#
# icmp for ping
#
#New-NetFirewallRule -DisplayName icmp4out -name icmp4out -Enabled True -Direction Outbound -Action Allow -ErrorAction Continue -Protocol ICMPv4 -Group Bernd
#
#New-NetFirewallRule -DisplayName icmp4in -name icmp4in -Enabled True -Direction Inbound -Action Allow -ErrorAction Continue -Protocol ICMPv4 -Group Bernd
#
#
#
# Mail APP local:
#
#New-NetFirewallRule -DisplayName TCP_Mail -name Mail_24_25_110_465_587_993_995 -RemotePort 24, 25, 110, 465, 587, 993, 995  -Enabled True -Direction Outbound -Action Allow -Protocol TCP -ErrorAction Continue -Group Bernd
#New-NetFirewallRule -DisplayName UDP_Mail -name Mail_24_25_465 -RemotePort 24, 25, 465 -Enabled True -Direction Outbound -Action Allow -Protocol UDP -ErrorAction Continue -Group Bernd
#
#
# Example for virtual Network:
#
#New-NetFirewallRule -DisplayName net3out -name net3out -LocalAddress 10.0.0.0/24 -RemoteAddress 10.0.0.0/24 -Enabled True -Direction Outbound -Action Allow -Protocol TCP -ErrorAction Continue -Group Bernd
#New-NetFirewallRule -DisplayName net3in -name net3in -LocalAddress 10.0.0.0/24 -RemoteAddress 10.0.0.0/24 -Enabled True -Direction Inbound -Action Allow -Protocol TCP -ErrorAction Continue -Group Bernd
#
#
#
# Firewall Status
#
Get-NetFirewallRule |
Format-Table -Property DisplayName,
@{Name='Protocol';Expression={($PSItem | Get-NetFirewallPortFilter).Protocol}},
@{Name='RemotePort';Expression={($PSItem | Get-NetFirewallPortFilter).RemotePort}},
Enabled,
Profile,
Direction,
Action
#
#
sleep -Seconds 1
#
Stop-Transcript
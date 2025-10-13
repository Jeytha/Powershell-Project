# 🛡️ Wonderville Host-Based Security Automation

PowerShell-based automation for a small municipal network — built for the **Wonderville IT Internship Case Study**.  
This repository provides a **turnkey host security automation** solution designed for small IT teams to deploy, monitor, and protect Windows-based systems.

---

## 📁 Repository Structure

wonderville-security-automation/
├── README.md
├── LICENSE
├── scripts/
│ ├── Monitor-Services.ps1
│ ├── Monitor-PowerShell.ps1
│ ├── Configure-Firewall.ps1
│ └── deploy.ps1
└── docs/
    └── deployment-notes.md

---

## ⚙️ Features

✅ Automated **Service & Process Monitoring**  
✅ **PowerShell Event Log Scanning** for suspicious activity  
✅ **Firewall Configuration & Hardening**  
✅ **Single-click Deployment** using `deploy.ps1`  
✅ **Automated Scheduled Tasks** for continuous monitoring

---

## 🧰 Prerequisites

1. **Windows 10/11** or **Windows Server 2016+**
2. **Administrator privileges** on the host machine(s)
3. **PowerShell 5.x** or **PowerShell 7+**
4. Execution Policy allowing local scripts:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Force

🚀 Quick Start (One-Step Deployment)

Run all commands as Administrator

# Step 1: Download and unzip the repository
cd C:\Users\<YourUsername>\Downloads
Expand-Archive wonderville-security-automation.zip -DestinationPath C:\wonderville

# Step 2: Navigate into the scripts folder
cd C:\wonderville\scripts

# Step 3: Deploy everything automatically
powershell -ExecutionPolicy Bypass -File .\deploy.ps1


This script will:

Copy all .ps1 files to C:\Scripts
Enable PowerShell Operational logging
Create 3 scheduled monitoring tasks
Create C:\Logs for local logging

🖥️ Scripts Overview
Script	                                      Purpose	                                                Log Output
Monitor-Services.ps1	      Logs top processes & detects abnormal services                   	C:\Logs\ServiceMonitor.log
Monitor-PowerShell.ps1	    Scans event logs for suspicious PowerShell activity	              C:\Logs\PowerShellMonitor.log
Configure-Firewall.ps1	    Sets up baseline firewall rules (RDP, SMB, DNS, HTTP/S)	          C:\Windows\System32\LogFiles\Firewall\pfirewall.log
deploy.ps1	                Installs, enables logs, and schedules all scripts	                N/A

🛠️ Configuration Parameters

Every .ps1 file includes an editable Parameters / Config section at the top.
Adjust them before running if needed.

Example (Configure-Firewall.ps1):
$InternalSubnet = "192.168.90.0/24"
$AllowRDPFromInternalName = "Allow RDP from Internal"
$AllowSMBName = "Allow SMB"
$AllowDNSName = "Allow DNS"
$AllowWebName = "Allow Web Traffic"


Example (Monitor-Services.ps1):
$LogFile = "C:\Logs\ServiceMonitor.log"
$ExpectedServices = @("WinDefend", "EventLog", "Dnscache", "TermService")

⏰ Scheduled Tasks (Auto-Created)

After running deploy.ps1, these scheduled tasks are automatically created:

Task Name	                  Interval	                          Runs As	Script
WV-Monitor-Services	      Every 5 minutes	SYSTEM	     C:\Scripts\Monitor-Services.ps1
WV-Monitor-PowerShell	    Every 5 minutes	SYSTEM	     C:\Scripts\Monitor-PowerShell.ps1
WV-Configure-Firewall	    Daily at 3:00 AM	SYSTEM	   C:\Scripts\Configure-Firewall.ps1

📊 Log Locations

Log Type             	      Path	                                                   Description
Service Monitor	     C:\Logs\ServiceMonitor.log	                            CPU usage + unexpected services
PowerShell Monitor	 C:\Logs\PowerShellMonitor.log	                        Suspicious PowerShell execution
Firewall Log	       C:\Windows\System32\LogFiles\Firewall\pfirewall.log	  Allowed / Blocked traffic

🧪 Testing the Scripts

✅ Test Service Monitor

Run a high-CPU process or start a new service, then check:
Get-Content C:\Logs\ServiceMonitor.log -Tail 20

✅ Test PowerShell Monitor

Run a safe encoded command:
powershell -EncodedCommand CmV2ZXJzZQ==

Check for alerts:
C:\Logs\PowerShellMonitor.log

✅ Test Firewall
Try RDP from internal and external IPs.
Internal IP: should connect ✅
External IP: should be blocked 🚫

🧹 Uninstall / Rollback

To remove all scheduled tasks:
schtasks /Delete /TN "WV-Monitor-Services" /F
schtasks /Delete /TN "WV-Monitor-PowerShell" /F
schtasks /Delete /TN "WV-Configure-Firewall" /F

To delete scripts and logs:
Remove-Item "C:\Scripts" -Recurse -Force
Remove-Item "C:\Logs" -Recurse -Force

To remove all created firewall rules:
Get-NetFirewallRule | Where DisplayName -Like "Allow*" | Remove-NetFirewallRule -Confirm:$false
Get-NetFirewallRule | Where DisplayName -Like "Block*" | Remove-NetFirewallRule -Confirm:$false

⚡ Troubleshooting
Issue	Fix
⚠️ “Execution of scripts is disabled”	Run PowerShell with -ExecutionPolicy Bypass
🚫 “Access denied”	Run as Administrator
🔁 Too many alerts	Update $ExpectedServices or regex in scripts
❌ No PowerShell log events	Run wevtutil set-log "Microsoft-Windows-PowerShell/Operational" /enabled:true

🧩 Extend the Project

Centralized Logging: Forward logs to SIEM (Splunk, Sentinel, ELK)
Email Alerts: Add Send-MailMessage for critical detections
Config File: Store parameters in config.json for easier updates
Threat Intel: Expand regex detections in Monitor-PowerShell.ps1

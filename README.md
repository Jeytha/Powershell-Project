# 🛡️ Host-Based Security Automation for a conceptualised case study

PowerShell-based automation for a small municipal network — built for the **Wonderville IT Internship Case Study**.  
This repository provides a **turnkey host security automation** solution designed for small IT teams to deploy, monitor, and protect Windows-based systems.

> **Important:** Designed for authorized use on your own systems or lab environments only. Do not run on systems where you lack permission.

---

## 📁 Repository Structure


```text
wonderville-security-automation/
├── README.md
├── LICENSE
├── scripts/
│   ├── Monitor-Services.ps1
│   ├── Monitor-PowerShell.ps1
│   ├── Configure-Firewall.ps1
│   └── deploy.ps1
└── docs/
    └── deployment-notes.md
```



---

## ⚙️ Features

```
- Automated Service & Process Monitoring
- PowerShell Event Log Scanning for suspicious activity
- Firewall Configuration & Hardening
- Single-click Deployment using deploy.ps1
- Automated Scheduled Tasks for continuous monitoring
- Local log collection for troubleshooting and SIEM forwarding
```

---

## 🧰 Prerequisites


```powershell
# Prerequisites (run as Admin)
# 1. Windows 10/11 or Windows Server 2016+
# 2. Administrator privileges
# 3. PowerShell 5.x or PowerShell 7+
# 4. Set execution policy (if required)
Set-ExecutionPolicy RemoteSigned -Force
```

---

## 🚀 Quick Start (One-Step Deployment)

> Run all commands as **Administrator**

**Step 1 — Download & extract**
```powershell
cd C:\Users\<YourUsername>\Downloads
Expand-Archive wonderville-security-automation.zip -DestinationPath C:\wonderville
```

**Step 2 — Change to scripts folder**
```powershell
cd C:\wonderville\scripts
```

**Step 3 — Deploy everything**
```powershell
powershell -ExecutionPolicy Bypass -File .\deploy.ps1
```

**What `deploy.ps1` will do (summary):**
```text
- Copy all .ps1 files to C:\Scripts
- Enable PowerShell Operational logging
- Create scheduled tasks (Service monitor, PowerShell monitor, daily firewall check)
- Create C:\Logs for local logging
```

---

## 🖥️ Scripts Overview 



| Script                    | Purpose                                                    | Log Output                                             |
|--------------------------:|-----------------------------------------------------------:|-------------------------------------------------------:|
| `Monitor-Services.ps1`    | Logs top processes & detects abnormal services             | `C:\Logs\ServiceMonitor.log`                           |
| `Monitor-PowerShell.ps1`  | Scans event logs for suspicious PowerShell activity        | `C:\Logs\PowerShellMonitor.log`                        |
| `Configure-Firewall.ps1`  | Sets up baseline firewall rules (RDP, SMB, DNS, HTTP/S)    | `C:\Windows\System32\LogFiles\Firewall\pfirewall.log`  |
| `deploy.ps1`              | Installs, enables logs, and schedules all scripts          | N/A                                                    |


```markdown
| Script                    | Purpose                                                    | Log Output                                             |
|--------------------------:|-----------------------------------------------------------:|-------------------------------------------------------:|
| `Monitor-Services.ps1`    | Logs top processes & detects abnormal services             | `C:\Logs\ServiceMonitor.log`                           |
| `Monitor-PowerShell.ps1`  | Scans event logs for suspicious PowerShell activity        | `C:\Logs\PowerShellMonitor.log`                        |
| `Configure-Firewall.ps1`  | Sets up baseline firewall rules (RDP, SMB, DNS, HTTP/S)    | `C:\Windows\System32\LogFiles\Firewall\pfirewall.log`  |
| `deploy.ps1`              | Installs, enables logs, and schedules all scripts          | N/A                                                    |
```

---

## 🛠️ Configuration Parameters

Each `.ps1` includes a config section at the top. Copy/paste these examples into your script headers and edit as needed.

**Configure-Firewall.ps1 — config example**
```powershell
# Configure-Firewall.ps1 - Parameters (edit for your environment)
$InternalSubnet = "192.168.90.0/24"
$AllowRDPFromInternalName = "Allow RDP from Internal"
$AllowSMBName = "Allow SMB"
$AllowDNSName = "Allow DNS"
$AllowWebName = "Allow Web Traffic"
$BlockExternalRDPName = "Block RDP from External"
```

**Monitor-Services.ps1 — config example**
```powershell
# Monitor-Services.ps1 - Parameters
$LogFile = "C:\Logs\ServiceMonitor.log"
$ExpectedServices = @("WinDefend","EventLog","Dnscache","TermService")
$HighCpuThresholdPercent = 80
$TopProcessCount = 10
```

**Monitor-PowerShell.ps1 — config example**
```powershell
# Monitor-PowerShell.ps1 - Parameters
$LogFile = "C:\Logs\PowerShellMonitor.log"
$EncodedCommandRegex = "EncodedCommand"
$SuspiciousParentProcesses = @("rundll32.exe","wscript.exe","cscript.exe")
$LookbackMinutes = 10
```

---

## ⏰ Scheduled Tasks (Auto-Created by `deploy.ps1`)



| Task Name                | Interval           | Runs As | Script                                          |
|-------------------------:|-------------------:|--------:|------------------------------------------------:|
| `WV-Monitor-Services`    | Every 5 minutes    | SYSTEM  | `C:\Scripts\Monitor-Services.ps1`               |
| `WV-Monitor-PowerShell`  | Every 5 minutes    | SYSTEM  | `C:\Scripts\Monitor-PowerShell.ps1`             |
| `WV-Configure-Firewall`  | Daily at 3:00 AM   | SYSTEM  | `C:\Scripts\Configure-Firewall.ps1`             |


```markdown
| Task Name                | Interval           | Runs As | Script                                          |
|-------------------------:|-------------------:|--------:|------------------------------------------------:|
| `WV-Monitor-Services`    | Every 5 minutes    | SYSTEM  | `C:\Scripts\Monitor-Services.ps1`               |
| `WV-Monitor-PowerShell`  | Every 5 minutes    | SYSTEM  | `C:\Scripts\Monitor-PowerShell.ps1`             |
| `WV-Configure-Firewall`  | Daily at 3:00 AM   | SYSTEM  | `C:\Scripts\Configure-Firewall.ps1`             |
```

---

## 📊 Log Locations



| Log Type           | Path                                                         | Description                         |
|-------------------:|--------------------------------------------------------------:|------------------------------------:|
| Service Monitor     | `C:\Logs\ServiceMonitor.log`                                  | CPU usage + unexpected services     |
| PowerShell Monitor  | `C:\Logs\PowerShellMonitor.log`                               | Suspicious PowerShell execution     |
| Firewall Log        | `C:\Windows\System32\LogFiles\Firewall\pfirewall.log`         | Allowed / Blocked traffic           |


```markdown
| Log Type           | Path                                                         | Description                         |
|-------------------:|--------------------------------------------------------------:|------------------------------------:|
| Service Monitor     | `C:\Logs\ServiceMonitor.log`                                  | CPU usage + unexpected services     |
| PowerShell Monitor  | `C:\Logs\PowerShellMonitor.log`                               | Suspicious PowerShell execution     |
| Firewall Log        | `C:\Windows\System32\LogFiles\Firewall\pfirewall.log`         | Allowed / Blocked traffic           |
```

---

## 🧪 Testing the Scripts

**Test Service Monitor (copy/paste):**
```powershell
# Simulate high CPU or start a test service, then view the latest log lines
Get-Content C:\Logs\ServiceMonitor.log -Tail 20
```

**Test PowerShell Monitor (copy/paste):**
```powershell
# Trigger detection with a safe encoded command (lab)
powershell -EncodedCommand CmV2ZXJzZQ==

# Check the monitor log
Get-Content C:\Logs\PowerShellMonitor.log -Tail 20
```

**Test Firewall (manual check):**
```text
# From internal host: attempt RDP -> should connect (if rule allows)
# From external host: attempt RDP -> should be blocked (if block rule applied)
```

---

## 🧹 Uninstall / Rollback

**Remove scheduled tasks (copy/paste):**
```powershell
schtasks /Delete /TN "WV-Monitor-Services" /F
schtasks /Delete /TN "WV-Monitor-PowerShell" /F
schtasks /Delete /TN "WV-Configure-Firewall" /F
```

**Delete scripts and logs (copy/paste):**
```powershell
Remove-Item "C:\Scripts" -Recurse -Force
Remove-Item "C:\Logs" -Recurse -Force
```

**Remove created firewall rules (use with caution):**
```powershell
Get-NetFirewallRule | Where DisplayName -Like "Allow*" | Remove-NetFirewallRule -Confirm:$false
Get-NetFirewallRule | Where DisplayName -Like "Block*" | Remove-NetFirewallRule -Confirm:$false
```

---

## ⚡ Troubleshooting



| Issue                                        | Fix |
|---------------------------------------------:|-----|
| ⚠️ “Execution of scripts is disabled”        | Run PowerShell with `-ExecutionPolicy Bypass` |
| 🚫 “Access denied”                            | Run as Administrator |
| 🔁 Too many alerts                            | Update `$ExpectedServices` or regex in scripts |
| ❌ No PowerShell log events                   | Run `wevtutil set-log "Microsoft-Windows-PowerShell/Operational" /enabled:true` |


```markdown
| Issue                                        | Fix |
|---------------------------------------------:|-----|
| ⚠️ “Execution of scripts is disabled”        | Run PowerShell with `-ExecutionPolicy Bypass` |
| 🚫 “Access denied”                            | Run as Administrator |
| 🔁 Too many alerts                            | Update `$ExpectedServices` or regex in scripts |
| ❌ No PowerShell log events                   | Run `wevtutil set-log "Microsoft-Windows-PowerShell/Operational" /enabled:true` |
```

---

## 🧩 Extend the Project

```
- Centralized Logging: Forward logs to SIEM (Splunk, Sentinel, ELK)
- Email Alerts: Add Send-MailMessage or webhook integration for critical detections
- Config File: Store parameters in config.json for easier updates across many hosts
- Threat Intel: Expand regex detections and IOCs in Monitor-PowerShell.ps1
- Hardening: Add CIS Benchmark checks and GPO enforcement scripts
```

**Sample `config.json` (optional):**
```json
{
  "InternalSubnet": "192.168.90.0/24",
  "LogPath": "C:\\Logs",
  "ExpectedServices": ["WinDefend","EventLog","Dnscache","TermService"],
  "MonitorIntervalMinutes": 5
}
```

---

## Security & Usage Notice

```
- This project is for authorized use only.
- Running monitoring or exploit-like scripts on networks you do not own or control is illegal.
- Always test in a controlled lab environment before deploying to production.
```

---



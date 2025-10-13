<#
Monitor-Services.ps1
Logs top resource-hogging processes and detects running services not in an expected whitelist.
#>

#region Parameters / Config - EDIT for your environment
# Path to log file
$LogFile = "C:\Logs\ServiceMonitor.log"

# Expected/whitelisted service short names (add any company-specific service names here)
$ExpectedServices = @(
    "WinDefend",   # Windows Defender
    "EventLog",    # Windows Event Log
    "W32Time",     # Windows Time
    "Spooler",     # Print Spooler
    "Dnscache",    # DNS Client
    "TermService"  # Remote Desktop Services
)

# Thresholds (example values)
$HighCpuThresholdPercent = 50
#endregion

# Ensure log directory exists
$logDir = Split-Path $LogFile -Parent
if (-not (Test-Path $logDir)) { New-Item -Path $logDir -ItemType Directory -Force | Out-Null }

Add-Content $LogFile "`n===== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ====="

try {
    # Top 10 processes by CPU
    $TopProcesses = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10
    Add-Content $LogFile "Top 10 Processes by CPU Usage:"
    foreach ($p in $TopProcesses) {
        $cpu = if ($p.CPU) { [math]::Round($p.CPU,2) } else { 0 }
        $memMB = [math]::Round($p.WorkingSet / 1MB, 2)
        Add-Content $LogFile ("{0,-25} CPU: {1,6}   Mem: {2} MB" -f $p.ProcessName, $cpu, $memMB)
    }

    # Check running services and compare with expected whitelist
    $RunningServices = Get-Service | Where-Object { $_.Status -eq "Running" }
    $UnusualServices = $RunningServices | Where-Object { $ExpectedServices -notcontains $_.Name }

    if ($UnusualServices -and $UnusualServices.Count -gt 0) {
        Add-Content $LogFile "`n[ALERT] Unusual Running Services Detected:"
        foreach ($s in $UnusualServices) {
            Add-Content $LogFile (" - {0} ({1})" -f $s.Name, $s.DisplayName)
        }
    } else {
        Add-Content $LogFile "`nNo unusual services detected."
    }
}
catch {
    Add-Content $LogFile "`n[ERROR] Exception: $($_.Exception.Message)"
}

<#
Monitor-PowerShell.ps1
Scans the Microsoft-Windows-PowerShell/Operational event log for suspicious activity and writes alerts.
#>

#region Parameters / Config - EDIT for your environment
$LogFile = "C:\Logs\PowerShellMonitor.log"
$MaxEvents = 100    # number of recent events to examine
#endregion

# Ensure log directory exists
$logDir = Split-Path $LogFile -Parent
if (-not (Test-Path $logDir)) { New-Item -Path $logDir -ItemType Directory -Force | Out-Null }

Add-Content $LogFile "`n===== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ====="

try {
    # Ensure the Operational channel is available
    $channel = "Microsoft-Windows-PowerShell/Operational"
    $Events = Get-WinEvent -LogName $channel -MaxEvents $MaxEvents -ErrorAction Stop

    foreach ($Event in $Events) {
        $Message = $Event.Message

        # Suspicious indicators - add more patterns as you discover them
        if ($Message -match "EncodedCommand" -or
            $Message -match "Invoke-WebRequest" -or
            $Message -match "DownloadString" -or
            $Message -match "IEX" -or
            $Message -match "FromBase64String") {

            Add-Content $LogFile "[ALERT] Suspicious PowerShell activity detected at $($Event.TimeCreated):"
            Add-Content $LogFile $Message
            Add-Content $LogFile ("EventID: {0}  Level: {1}  Provider: {2}" -f $Event.Id, $Event.LevelDisplayName, $Event.ProviderName)
            Add-Content $LogFile ("-" * 80)
        }
    }

    Add-Content $LogFile "Scan complete. Events scanned: $($Events.Count)"
}
catch {
    Add-Content $LogFile "`n[ERROR] Could not read events from $channel - $($_.Exception.Message)"
}

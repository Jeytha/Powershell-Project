<#
deploy.ps1
Automates installing files to C:\Scripts, enabling PowerShell Operational log, and creating scheduled tasks.
Requires elevated (Administrator) PowerShell.
#>

# Parameters - edit before running if needed
$SourceDir = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$TargetDir = "C:\Scripts"
$Tasks = @(
    @{Name="WV-Monitor-Services"; Script="C:\Scripts\Monitor-Services.ps1"; Schedule="MINUTE"; Mod=5},
    @{Name="WV-Monitor-PowerShell"; Script="C:\Scripts\Monitor-PowerShell.ps1"; Schedule="MINUTE"; Mod=5},
    @{Name="WV-Configure-Firewall"; Script="C:\Scripts\Configure-Firewall.ps1"; Schedule="DAILY"; Time="03:00"}
)

if (-not ([bool] (whoami /groups 2>$null | Select-String "S-1-5-32-544"))) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Create target dir and copy files
New-Item -Path $TargetDir -ItemType Directory -Force | Out-Null
Get-ChildItem -Path $SourceDir -Filter *.ps1 -File | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $TargetDir -Force
}

# Ensure logs directory exists
New-Item -Path "C:\Logs" -ItemType Directory -Force | Out-Null

# Enable PowerShell Operational channel
try {
    wevtutil set-log "Microsoft-Windows-PowerShell/Operational" /enabled:true
    Write-Output "Enabled Microsoft-Windows-PowerShell/Operational log."
} catch {
    Write-Warning "Could not enable PowerShell Operational log: $($_.Exception.Message)"
}

# Create scheduled tasks
foreach ($t in $Tasks) {
    $taskName = $t.Name
    $script = $t.Script
    # Remove existing task
    schtasks /Delete /TN $taskName /F > $null 2>&1
    if ($t.Schedule -eq "MINUTE") {
        schtasks /Create /SC MINUTE /MO $t.Mod /TN $taskName /TR "powershell -NoProfile -ExecutionPolicy Bypass -File `"$script`"" /RU "SYSTEM" /F | Out-Null
        Write-Output "Created task $taskName to run every $($t.Mod) minute(s)."
    } else {
        schtasks /Create /SC $t.Schedule /TN $taskName /TR "powershell -NoProfile -ExecutionPolicy Bypass -File `"$script`"" /ST $t.Time /RU "SYSTEM" /F | Out-Null
        Write-Output "Created task $taskName scheduled $($t.Schedule) at $($t.Time)."
    }
}

Write-Output "Deployment complete. Scripts copied to $TargetDir and scheduled."


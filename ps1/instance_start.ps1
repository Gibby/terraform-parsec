# Allow running scripts from the web...
Set-ExecutionPolicy Bypass -Scope Process -Force

# Custom vars
$SourceRepo = "https://raw.githubusercontent.com/Gibby/terraform-parsec/master/ps1"
$ScriptsToRun = "enable-rdp.ps1
initialise-ephemeral-disks.ps1
bind-steam-library.ps1"

# Get Current date/time
$DateTime = (Get-Date -UFormat "%Y%m%d-%H%M")

# Set working dir
$ScriptDir = "C:\terraform-parsec"

# Create our directory
New-Item -ItemType directory -Path $ScriptDir

# Create logfile and send to System logs
Start-Job {$out = @'
{
  "events": [
    {
      "logName": "System",
      "source": "",
      "level": "Information",
      "numEntries": 3
    }
  ]
}
'@ | Out-File 'C:\ProgramData\Amazon\EC2-Windows\Launch\Config\EventLogConfig.json'

C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\SendEventLogs.ps1 -Schedule

$LogFile = $ScriptDir\logs.$DateTime.txt
Add-Content -Value "Starting custom scripts..." -Path $LogFile
Get-Content -Path $LogFile -Wait | Write-EventLog System -source System -eventid 12345 -message $_}
Start-Sleep -s 15

# Download and run scripts
Foreach ($script in $ScriptsToRun)
{
  Start-BitsTransfer -Source "$SourceRepo\$script" -Destination $ScriptDir\$script
  Invoke-Expression -Command "$ScriptDir\$script" *>> $LogFile
}

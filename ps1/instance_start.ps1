# Custom vars
$SourceRepo = "https://raw.githubusercontent.com/Gibby/terraform-parsec/master/ps1"
$InitScript = "instance_start.ps1"
$ScriptsToRun = @("initialise-disks.ps1", "bind-steam-library.ps1", "extra-apps.ps1")

# Get Current date/time
$DateTime = (Get-Date -UFormat "%Y%m%d-%H%M")

# Set working dir
$ScriptDir = "C:\terraform-parsec"

# Create our directory
if (-not (Test-Path -Path $ScriptDir)) {
  New-Item -ItemType directory -Path $ScriptDir
}

# Logs
$LogFile = "${ScriptDir}\logs.${DateTime}.txt"
Add-Content -Value "Starting custom scripts..." -Path $LogFile

# Pull the init script down if needed again
Invoke-WebRequest -Uri "${SourceRepo}/${InitScript}" -OutFile "${ScriptDir}/${InitScript}" *> $LogFile

# Download and run scripts
Foreach ($script in $ScriptsToRun)
{
  Invoke-WebRequest -Uri "${SourceRepo}/${script}" -OutFile "${ScriptDir}/${script}" *> $LogFile
  & "${ScriptDir}/${script}" *> $LogFile
}

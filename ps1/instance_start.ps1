# Custom vars
$SourceRepo = "https://raw.githubusercontent.com/Gibby/terraform-parsec/master/ps1"
$ScriptsToRun = @("initialise-disks.ps1", "bind-steam-library.ps1")

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


# Download and run scripts
Foreach ($script in $ScriptsToRun)
{
  Invoke-WebRequest -Uri "${SourceRepo}/${script}" -OutFile "${ScriptDir}/${script}"
  & "${ScriptDir}/${script}"
}

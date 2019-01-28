# Get Current date/time
$DateTime = (Get-Date -UFormat "%Y%m%d-%H%M")

# Set working dir
$ScriptDir = C:\terraform-parsec

# Create directory for logging
New-Item -ItemType directory -Path $ScriptDir

# Create logfile
$LogFile = $ScriptDir\logs.$DateTime.txt

# List of scripts to run
$SourceRepo = "https://raw.githubusercontent.com/Gibby/terraform-parsec/master/ps1"
$ScriptsToRun = "Initialise-Ephemeral-Disks.ps1
Bind-Steam-Library.ps1"

# Run scscripts from ScriptScriptsToRun
Foreach ($script in $ScriptsToRun)
{
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString("$SourceRepo\$script")) *> $LogFile
}

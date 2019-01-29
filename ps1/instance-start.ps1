# Custom vars
$SourceRepo = "https://raw.githubusercontent.com/Gibby/terraform-parsec/master/ps1"
$InitScript = "instance-start.ps1"
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
if (Test-Path "${ScriptDir}/${InitScript}") {
  Remove-Item "${ScriptDir}/${InitScript}"
}
Invoke-WebRequest -Uri "${SourceRepo}/${InitScript}" -OutFile "${ScriptDir}/${InitScript}"

# Download and run scripts
Foreach ($script in $ScriptsToRun)
{
  $SrcFile = "${SourceRepo}/${script}"
  $DstFile = "${ScriptDir}/${script}"
  if (Test-Path $DstFile) {
    Remove-Item $DstFile
  }
  Invoke-WebRequest -Uri "${SrcFile}" -OutFile "${DstFile}"
  Invoke-Expression -Command "${DstFile}" | Out-File -FilePath "$LogFile" -Append
}

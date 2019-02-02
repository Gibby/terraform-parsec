# Custom vars
C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -Schedule
$SourceRepo = "https://raw.githubusercontent.com/Gibby/terraform-parsec/master/ps1"
$InitScript = "instance-start.ps1"
$ScriptsToRun = @("ec2-console-logging.ps1", "win16-fix-meta-data.ps1", "set-hostname.ps1", "initialise-disks.ps1", "extra-apps.ps1", "create-shutdown-file.ps1", "disable-windows-firewall.ps1")

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
  Invoke-Expression -Command "${DstFile}" *>> "$LogFile"
}

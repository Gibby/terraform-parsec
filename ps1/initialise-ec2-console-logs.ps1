$out = @'
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
Get-Content -Path $LogFile -Wait | Write-EventLog System -source System -eventid 12345 -message $_

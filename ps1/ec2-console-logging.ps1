$OutFile = "C:\ProgramData\Amazon\EC2-Windows\Launch\Config\EventLogConfig.json"

$FileContent = @"
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
"@
Set-Content -Encoding ASCII -Value $FileContent -Path $OutFile
C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\SendEventLogs.ps1 -Schedule

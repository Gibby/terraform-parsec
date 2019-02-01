$OutFile = "C:\Users\Administrator\Desktop\shutdown.bat"

$FileContent = @"
Powershell.exe -executionpolicy remotesigned -File C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -Schedule


shutdown.exe /s /t 00

"@
Set-Content -Encoding ASCII -Value $FileContent -Path $OutFile

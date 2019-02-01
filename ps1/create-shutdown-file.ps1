if (Test-Path -Path D:\) {
  $LibraryFolders = "C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf"

  New-Item -ItemType directory -Path "D:\SteamLibrary" -Force

  (Get-Content $LibraryFolders) -replace "}", "`"1`" `"D:\SteamLibrary`" }" | Out-File $LibraryFolders

}

$OutFile = "C:\Users\Administrator\Desktop\shutdown.bat"

$FileContent = @"
Powershell.exe -executionpolicy remotesigned -File C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -Schedule
shutdown.exe /s /t 00
"@ | Out-File $OutFile

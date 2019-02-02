if (Test-Path -Path D:\) {
  $LibraryFolders = "C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf"

  if (-not (Test-Path -Path D:\SteamLibrary)) {
    New-Item -ItemType directory -Path "D:\SteamLibrary" -Force
  }

  (Get-Content $LibraryFolders) -replace "}", "`"1`" `"D:\SteamLibrary`" }" | Out-File $LibraryFolders

}

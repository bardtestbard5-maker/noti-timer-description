@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "$WshShell = New-Object -ComObject WScript.Shell; $Desktop = [Environment]::GetFolderPath('Desktop'); $Shortcut = $WshShell.CreateShortcut(\"$Desktop\Timer Notify.lnk\"); $Shortcut.TargetPath = '%~dp0timer-notify.bat'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.IconLocation = \"$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe,0\"; $Shortcut.Description = 'Set a countdown timer that shows a Windows notification'; $Shortcut.Save(); Write-Output \"Shortcut created at $Desktop\Timer Notify.lnk\""
pause

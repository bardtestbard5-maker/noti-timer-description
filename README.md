# Timer Notify

A simple desktop timer that pops a persistent Windows toast notification
after a set number of minutes.

## Setup (pick one)

**Option A - use the installer**
1. Unzip / clone this folder anywhere.
2. Double-click `install-shortcut.bat`.
3. A shortcut named **"Timer Notify"** appears on your Desktop.

**Option B - do it yourself**
1. Right-click `timer-notify.bat` -> **Send to** -> **Desktop (create shortcut)**.
2. Rename the new desktop shortcut if you like.

Both methods produce a working double-click shortcut on your Desktop.

## Usage

1. Double-click the **Timer Notify** desktop shortcut.
2. At the prompt, type minutes and an optional label, then press Enter:
   - `30 Gold` -> waits 30 minutes, notification titled "Gold"
   - `5` -> waits 5 minutes, notification titled "Timer Finished"
3. Press `Ctrl+C` any time during the countdown to cancel.
4. When time is up, a Windows toast notification appears and stays on
   screen until you dismiss it.
5. After the notification, the window loops back to accept a new timer.
   Close the window whenever you're done.

## Files

- `timer-notify.ps1` - core timer/notification logic
- `timer-notify.bat` - double-clickable launcher for the script above
- `install-shortcut.bat` - creates a Desktop shortcut pointing to `timer-notify.bat`

$Host.UI.RawUI.WindowTitle = "Timer Notify"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$AppId = "TimerAlert.App"

function Register-ToastApp {
    param([string]$AppId, [string]$DisplayName)
    $regPath = "HKCU:\Software\Classes\AppUserModelId\$AppId"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    New-ItemProperty -Path $regPath -Name "DisplayName" -Value $DisplayName -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $regPath -Name "IconUri" -Value "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force | Out-Null
}

Register-ToastApp -AppId $AppId -DisplayName "Timer Alert"

function Show-ToastOrBalloon {
    param(
        [string]$Title,
        [string]$Message
    )

    $toastOk = $true
    try {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

        $template = @"
<toast scenario="reminder">
    <visual>
        <binding template="ToastGeneric">
            <text>$Title</text>
            <text>$Message</text>
        </binding>
    </visual>
    <actions>
        <action activationType="system" arguments="dismiss" content="Dismiss" />
    </actions>
    <audio src="ms-winsoundevent:Notification.Reminder" />
</toast>
"@

        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml($template)
        $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
        $toast.Tag = "TimerAlert-$([Guid]::NewGuid().ToString('N'))"
        $toast.Group = "TimerAlert"
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($toast)
    } catch {
        $toastOk = $false
    }

    if (-not $toastOk) {
        [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
    }
}

while ($true) {
    do {
        $inputLine = Read-Host "Enter minutes [optional detail], e.g. '30 Gold', then press Enter"
        $inputLine = $inputLine.Trim()
        $match = [regex]::Match($inputLine, '^(\d+(\.\d+)?)\s*(.*)$')
    } while (-not $match.Success -or [double]$match.Groups[1].Value -le 0)

    $minutes = [double]$match.Groups[1].Value
    $detail = $match.Groups[3].Value.Trim()
    $totalSeconds = [int]($minutes * 60)

    Write-Host ""
    Write-Host "Waiting $minutes minute(s)... (Ctrl+C to cancel)"

    $endTime = (Get-Date).AddSeconds($totalSeconds)
    while ((Get-Date) -lt $endTime) {
        $remaining = [math]::Ceiling(($endTime - (Get-Date)).TotalSeconds)
        Write-Host -NoNewline "`rTime remaining: $remaining sec   "
        Start-Sleep -Seconds 1
    }
    Write-Host ""

    if ($detail) {
        Show-ToastOrBalloon -Title $detail -Message "$minutes minute(s) have passed!"
    } else {
        Show-ToastOrBalloon -Title "Timer Finished" -Message "$minutes minute(s) have passed!"
    }

    Write-Host "Done! Ready for next timer (close this window when you're finished)."
    Write-Host ""
}

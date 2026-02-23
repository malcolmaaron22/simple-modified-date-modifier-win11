<#
Reset-ModifiedDate.ps1
Purpose: Reset "Date modified" (LastWriteTime) to a chosen time for ALL files + folders UNDER a given path.
OneDrive-safe: Does NOT touch the root folder itself (common lock by OneDrive.exe / Windows).
#>

Write-Host "============================================================"
Write-Host " Reset 'Date modified' for Files + Folders (OneDrive-safe)"
Write-Host "============================================================"
Write-Host ""
Write-Host "MANDATORY (OneDrive): Ensure ALL items show GREEN checkmarks before running."
Write-Host "If syncing (blue arrows) or errors (red X) exist, OneDrive may back-sync old timestamps."
Write-Host "To do so, right click any folders, then click Always Keep On This Device"
Write-Host ""
Write-Host "Script vibecoded by Malcolm Aaron, MYMVID, should there be any issue, do consult CoPilot as experience may varies ;)"
Write-Host "Use Windows Powershell or Visual Studio Code to run this script"
Write-Host ""

# --- Get path from user ---
$inputPath = Read-Host "Paste the folder path (example: C:\Users\M.VincentBuyun\OneDrive - Shell\01_INBOX_DUMP)"
$inputPath = $inputPath.Trim().Trim('"')   # removes whitespace + wrapping quotes if pasted as "C:\path"

if (-not (Test-Path -LiteralPath $inputPath)) {
    Write-Host ""
    Write-Host "ERROR: Path not found:" -ForegroundColor Red
    Write-Host "  $inputPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Tip: In File Explorer: Shift + Right-click folder -> Copy as path, then paste here."
    exit 1
}

Write-Host ""
Write-Host "Choose timestamp mode:" -ForegroundColor Cyan
Write-Host "  1) NOW (current date/time)"
Write-Host "  2) TODAY at 00:00 (midnight)"
Write-Host "  3) Custom date/time (e.g., 2026-02-20 17:30:00)"
$choice = Read-Host "Enter 1, 2, or 3"

switch ($choice) {
    "2" { $targetTime = (Get-Date).Date }
    "3" {
        $custom = Read-Host "Enter custom date/time (examples: '2026-02-20 17:30:00' or '20 Feb 2026 5:30 PM')"
        try { $targetTime = [datetime]::Parse($custom) }
        catch {
            Write-Host ""
            Write-Host "ERROR: Could not parse date/time: $custom" -ForegroundColor Red
            Write-Host "Try format: 2026-02-20 17:30:00" -ForegroundColor Yellow
            exit 1
        }
    }
    default { $targetTime = Get-Date }
}

Write-Host ""
Write-Host "Target path:" -ForegroundColor Cyan
Write-Host "  $inputPath"
Write-Host "Setting 'Date modified' (LastWriteTime) to:" -ForegroundColor Cyan
Write-Host "  $targetTime"
Write-Host ""
Write-Host "Processing... (files + folders, recursive; root folder not modified)" -ForegroundColor Yellow

# --- Work ---
$errors = 0
$updated = 0

try {
    Get-ChildItem -LiteralPath $inputPath -Recurse -Force -ErrorAction SilentlyContinue |
        ForEach-Object {
            try {
                $_.LastWriteTime = $targetTime
                $updated++
            }
            catch {
                $errors++
            }
        }

    Write-Host ""
    Write-Host "DONE!" -ForegroundColor Green
    Write-Host "Updated items: $updated" -ForegroundColor Green
    if ($errors -gt 0) {
        Write-Host "Skipped/failed items (locked/protected): $errors" -ForegroundColor Yellow
        Write-Host "Tip: This is normal for some system-managed or in-use items."
    }

    Write-Host ""
    Write-Host "Verify: Right-click any file/folder -> Properties -> Date modified"
}
catch {
    Write-Host ""
    Write-Host "FAILED with error:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
``
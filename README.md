# simple-modified-date-modifier-win11
Tired of files missing every now and then without you knowing by System Account? Change in bulk of any files and folders modified date within designated path in Windows 11! As the countdown depend on the last modified date + 3Y. 
### Reset OneDrive "Date Modified" for Files & Folders (Windows)
This **combined guide** consolidates both approaches into a **single, reusable reference** suitable for saving in your **Copilot Notebook**:
- **1. Direct PowerShell commands** (quick, ad‑hoc use)
- **2. Interactive PowerShell (.ps1) script** (safe, repeatable SOP)
- **3. Easiest Way, Done For You** Relate to method 2, I've already created the ps1 file for you in this GitHub, just download from the main branch [Click the ps1 file, then download button on the right], then, on your computer, right click, go Properties, click unblock then click ok. Then right click again on the file and click "Run on PowerShell", then follow the instruction.

All methods are **OneDrive‑safe when used correctly** and do **not modify file contents**.
### ⚠️ Mandatory OneDrive Requirement (Non‑Negotiable)
**Before running _any_ command or script:**
- ✅ **ALL files and folders must show GREEN checkmarks** in File Explorer
- ❌ Do **NOT** proceed if you see:
  - Blue syncing arrows
  - Red error icons
If OneDrive is still syncing, it **will back‑sync old cloud metadata** and **undo your timestamp changes**.
### PART A — Quick PowerShell Commands (Files + Folders)
Use this when you just need a **one‑off reset** and don’t need prompts or reusability.
#### 1️⃣ Open PowerShell
You can open PowerShell from **any location** (path does not matter).
**Method A (Recommended)**
- Press **Win + X** → **Windows Terminal / PowerShell**
**Method B**
- Press **Win + S**, type **PowerShell**, press **Enter**
#### 2️⃣ Get the Full Folder Path
**Method A — Address Bar (Easiest)**
- Open **File Explorer**
- Navigate to the target folder
- Click the address bar (turns blue)
- Copy the full path
Example:
```
C:\Users\M.VincentBuyun\OneDrive - Shell\01_INBOX
```
**Method B — Shift + Right‑Click**
- Hold **Shift** → Right‑click folder → **Copy as path**
#### 3️⃣ Set "Date Modified" to NOW (Files + Folders)
```
$now = Get-Date
Get-ChildItem "C:\Users\M.VincentBuyun\OneDrive - Shell\01_INBOX" -Recurse -Force |
 ForEach-Object { $_.LastWriteTime = $now }
```
#### 4️⃣ Set "Date Modified" to Today at 00:00 (Midnight)
```
$midnight = (Get-Date).Date
Get-ChildItem "C:\Users\M.VincentBuyun\OneDrive - Shell\01_INBOX" -Recurse -Force |
 ForEach-Object { $_.LastWriteTime = $midnight }
```
#### 5️⃣ Verify Results
- Right‑click any file or folder → **Properties**
- Confirm **Date modified** is updated
- Ensure OneDrive status remains **green**
### PART B — Interactive PowerShell Script (Recommended SOP)
Use this when you want a **safe, reusable, and guided** solution.
#### 1️⃣ Create the .ps1 Script
- Open **Notepad**
- Paste the script below
- Save as:
  - **File name:** Reset-ModifiedDate.ps1
  - **Save as type:** All Files
  - **Encoding:** UTF‑8
Suggested location:
```
C:\Users\M.VincentBuyun\OneDrive - Shell\Documents
```
#### 2️⃣ OneDrive‑Safe Interactive Script
```
<#
Reset-ModifiedDate.ps1
Purpose: Reset "Date modified" (LastWriteTime) for ALL files + folders under a given path.
OneDrive-safe: Does NOT touch the root folder itself.
#>
Write-Host "============================================================"
Write-Host " Reset 'Date modified' for Files + Folders (OneDrive-safe)"
Write-Host "============================================================"
Write-Host ""
Write-Host "MANDATORY: Ensure ALL OneDrive items show GREEN checkmarks before running."
Write-Host "If syncing is active, OneDrive may back-sync old timestamps."
Write-Host ""
# Prompt for path
$inputPath = Read-Host "Paste the folder path (e.g. C:\Users\M.VincentBuyun\OneDrive - Shell\01_INBOX)"
$inputPath = $inputPath.Trim().Trim('\"')
# Validate path
if (-not (Test-Path -LiteralPath $inputPath)) {
 Write-Host "ERROR: Path not found:" -ForegroundColor Red
 Write-Host " $inputPath" -ForegroundColor Red
 exit 1
}
Write-Host ""
Write-Host "Choose timestamp mode:" -ForegroundColor Cyan
Write-Host " 1) NOW (current date/time)"
Write-Host " 2) TODAY at 00:00 (midnight)"
Write-Host " 3) Custom date/time"
$choice = Read-Host "Enter 1, 2, or 3"
switch ($choice) {
 "2" { $targetTime = (Get-Date).Date }
 "3" {
 $custom = Read-Host "Enter custom date/time (e.g. 2026-02-20 17:30:00)"
 try { $targetTime = [datetime]::Parse($custom) }
 catch {
 Write-Host "Invalid date format." -ForegroundColor Red
 exit 1
 }
 }
 default { $targetTime = Get-Date }
}
Write-Host ""
Write-Host "Target path:" -ForegroundColor Cyan
Write-Host " $inputPath"
Write-Host "Setting Date modified to:" -ForegroundColor Cyan
Write-Host " $targetTime"
Write-Host ""
Write-Host "Processing... (files + folders, recursive)" -ForegroundColor Yellow
$updated = 0
$errors = 0
Get-ChildItem -LiteralPath $inputPath -Recurse -Force -ErrorAction SilentlyContinue |
 ForEach-Object {
 try {
 $_.LastWriteTime = $targetTime
 $updated++
 }
 catch { $errors++ }
 }
Write-Host ""
Write-Host "DONE" -ForegroundColor Green
Write-Host "Updated items: $updated" -ForegroundColor Green
if ($errors -gt 0) {
 Write-Host "Skipped/locked items: $errors (normal for system-managed files)" -ForegroundColor Yellow
}
```
### 3️⃣ Run the Script
```
cd "C:\Users\M.VincentBuyun\OneDrive - Shell\Documents"
.\Reset-ModifiedDate.ps1
```
### 4️⃣ If You See "Running Scripts Is Disabled"
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
One‑time run:
```
powershell -ExecutionPolicy Bypass -File "C:\Users\M.VincentBuyun\OneDrive - Shell\Documents\Reset-ModifiedDate.ps1"
```
### Final Notes
- Wait for green checkmarks
- Prefer the script for repeatable SOP


# simple-modified-date-modifier-win11
😔 Tired of files missing every now and then without you knowing by System Account?

😧 Just realized that your company's NRD policy is also applicable to your OneDrive?

Change in ✨**BULK**✨ of any files and folders modified date within designated path in Windows 11 within 2 minutes! As the NRD countdown depend on the last modified date + 3Y, hopefully this ease your troubled mind of the missing files situation. 😉

### Reset OneDrive "Date Modified" for Files & Folders (Windows)
Few methods, click below to expand:
- **1. Download and Run** (quickest)
- **2. Direct PowerShell commands** (quick, ad‑hoc use)
- **3. Interactive PowerShell (.ps1) + cmd script** (safe, repeatable SOP)

All methods are **OneDrive‑safe when used correctly** and do **not modify file contents**.
### ⚠️ Mandatory OneDrive Requirement (Non‑Negotiable)
**Before running _any_ command or script:**
- ✅ **ALL files and folders must show [GREEN](https://www.youtube.com/watch?v=wZykMg1ytaI&pp=ygUfaG93IHRvIGtlZXAgZ3JlZW4gdGljayBvbmVkcml2ZQ%3D%3D) checkmarks** in File Explorer
   - Right click on selected folders and click "Always Keep on Device"

- ❌ Do **NOT** proceed if you see:
  - Blue syncing arrows
  - Red error icons
If OneDrive is still syncing, it **will back‑sync old cloud metadata** and **undo your timestamp changes**.


<details>
<summary><strong>METHOD 1</strong></summary>

  
### METHOD 1 - Download and Run
Relate to method 3, simplified, I've already created the ps1 file for you in this GitHub
#### 1️⃣ Download
Just download from the [main branch](https://github.com/malcolmaaron22/simple-modified-date-modifier-win11/tree/main) (click Code and Download Zip) or here: [simple-modified-date-modifier-win11.zip](https://github.com/malcolmaaron22/simple-modified-date-modifier-win11/archive/refs/heads/main.zip), 
#### 2️⃣ Run
Double click on the Run-Reset-ModifiedDate.cmd file.
#### Tips:
Make sure both ps1 and cmd file are in the same folder all the time as the cmd file wrap and run the ps1.

</details>

<details>
<summary><strong>METHOD 2</strong></summary>

### Method 2 — Direct PowerShell Commands (Files + Folders)
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

</details>

<details>
<summary><strong>METHOD 3</strong></summary>
  
### Method 3 — Interactive PowerShell Script + CMD
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
### 3️⃣ Create the wrapper cmd file
Open a new **Notepad**
copy paste this code below:
```
@echo off
setlocal

REM ============================================================
REM OneDrive-safe launcher for Reset-ModifiedDate.ps1
REM Double-click to run, no PowerShell policy issues
REM ============================================================

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Reset-ModifiedDate.ps1"

pause
```
- Save as:
  - **File name:** Run-Reset-ModifiedDate.cmd
  - **Save as type:** All Files
  - **Encoding:** UTF‑8
  - Make sure the file location is the same as the existing ps1 file.

### Why two files?
* Powershell and CMD are two different languages with different functions
* Powershell does the data parsing, object properties and user prompts
* CMD help to bypasses execution policy and acts as a wrapper for the ps1 file. i.e. can double click to run


</details>

### Final Notes
- Wait for green checkmarks in OneDrive, no cloud icon else the changes will be reverted
- This serves as a temporary mitigation. Original approach of the respective company's NRD policy should still be adhered. 
- Utilization of Copilot was done for the vibe code of this approach. Review and Testing phase on the codes completed.


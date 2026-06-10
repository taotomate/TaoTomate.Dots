# install.ps1
# Installation script for TaoTomate.Dots agent configurations via Symlinks.

$ErrorActionPreference = "Stop"

# 1. Verification of Permissions
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$devMode = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense -eq 1

if (-not $isAdmin -and -not $devMode) {
    Write-Error "CRITICAL: Creating symbolic links on Windows requires either Administrative privileges OR Windows Developer Mode enabled."
    Write-Host "Please run this script in an Elevated PowerShell Window (Run as Administrator) or enable Developer Mode in Windows Settings." -ForegroundColor Red
    Exit 1
}

# 2. Submodule Initialization Check
$repoRoot = $PSScriptRoot
if (-not (Test-Path "$repoRoot\agent-config\shared\agents.md")) {
    Write-Host "Initializing agent-config git submodule..." -ForegroundColor Cyan
    git -C $repoRoot submodule update --init --recursive
}

$userProfile = [System.Environment]::GetFolderPath("UserProfile")

# Helper function to safely backup existing target paths
function Save-Backup {
    param (
        [string]$TargetPath
    )
    if (Test-Path $TargetPath) {
        # Check if it's already a symlink (we don't backup symlinks, we just remove them)
        $item = Get-Item $TargetPath
        if ($item.Attributes -match "ReparsePoint") {
            Write-Host "Removing existing symlink: $TargetPath" -ForegroundColor Yellow
            Remove-Item $TargetPath -Force
            return
        }

        # Safe backup naming with timestamps to avoid collisions
        $timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
        $backupPath = "$TargetPath.bak_$timestamp"
        
        Write-Host "Backing up existing configuration to: $backupPath" -ForegroundColor Cyan
        Move-Item -Path $TargetPath -Destination $backupPath -Force
    }
}

# Helper function to create symlinks safely
function Create-Symlink {
    param (
        [string]$SourcePath,
        [string]$DestinationPath,
        [string]$Type # "File" or "Directory"
    )
    
    # Ensure destination parent folder exists
    $parentDir = Split-Path $DestinationPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # Backup if exists
    Save-Backup -TargetPath $DestinationPath

    # Create link
    Write-Host "Creating symlink: $DestinationPath -> $SourcePath" -ForegroundColor Green
    try {
        New-Item -ItemType SymbolicLink -Path $DestinationPath -Value $SourcePath -ErrorAction Stop | Out-Null
    } catch {
        Write-Host "CRITICAL ERROR: Failed to create symbolic link at $DestinationPath" -ForegroundColor Red
        Write-Host "Error details: $_" -ForegroundColor DarkRed
        Write-Host "Ensure you are running PowerShell as Administrator." -ForegroundColor Yellow
        Exit 1
    }
}


Write-Host "=== TaoTomate.Dots Agent Configuration Installer ===" -ForegroundColor Green

# 3. Configure Gemini/Antigravity
$geminiSkillsDest = Join-Path $userProfile ".gemini\config\skills"
$sharedSource = Join-Path $repoRoot "agent-config\shared"
$sharedDest = Join-Path $geminiSkillsDest "_shared"

# Link _shared folder
Create-Symlink -SourcePath $sharedSource -DestinationPath $sharedDest -Type "Directory"

# Link individual skills
$skillsSourceRoot = Join-Path $repoRoot "agent-config\skills"
if (Test-Path $skillsSourceRoot) {
    Get-ChildItem -Directory -Path $skillsSourceRoot | ForEach-Object {
        $skillName = $_.Name
        $destPath = Join-Path $geminiSkillsDest $skillName
        Create-Symlink -SourcePath $_.FullName -DestinationPath $destPath -Type "Directory"
    }
}

# 4. Configure Claude Code
$clauderulesDest = Join-Path $userProfile ".clauderules"
$agentsFileSource = Join-Path $repoRoot "agent-config\shared\agents.md"
Create-Symlink -SourcePath $agentsFileSource -DestinationPath $clauderulesDest -Type "File"

# 5. Configure OpenCode
$opencodeDest = Join-Path $userProfile ".config\opencode\AGENTS.md"
Create-Symlink -SourcePath $agentsFileSource -DestinationPath $opencodeDest -Type "File"

# 6. Configure Hermes Agent
$hermesSoulDest = Join-Path $userProfile ".hermes\SOUL.md"
Create-Symlink -SourcePath $agentsFileSource -DestinationPath $hermesSoulDest -Type "File"

$hermesSkillsDest = Join-Path $userProfile ".hermes\skills"
if (Test-Path $skillsSourceRoot) {
    Get-ChildItem -Directory -Path $skillsSourceRoot | ForEach-Object {
        $skillName = $_.Name
        $destPath = Join-Path $hermesSkillsDest $skillName
        Create-Symlink -SourcePath $_.FullName -DestinationPath $destPath -Type "Directory"
    }
}

# 7. Configure WezTerm
$weztermDest = Join-Path $userProfile ".wezterm.lua"
$weztermSource = Join-Path $repoRoot ".wezterm.lua"
Create-Symlink -SourcePath $weztermSource -DestinationPath $weztermDest -Type "File"

# 8. Configure Starship
$starshipDest = Join-Path $userProfile ".config\starship.toml"
$starshipSource = Join-Path $repoRoot "starship.toml"
Create-Symlink -SourcePath $starshipSource -DestinationPath $starshipDest -Type "File"

Write-Host "Sincronización de Symlinks completada exitosamente!" -ForegroundColor Green

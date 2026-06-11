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

# 3. Auto-Installer for Dependencies (Modo Ninite)
Write-Host "=== Verificando Dependencias (WezTerm / Starship) ===" -ForegroundColor Cyan

if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Scoop (Gestor de paquetes silencioso)..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    # Scoop rejects Admin shells by default, so we use -RunAsAdmin
    Invoke-Expression "& {$(Invoke-RestMethod -Uri https://get.scoop.sh)} -RunAsAdmin"
}

if (-not (Get-Command "wezterm" -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando WezTerm silenciosamente..." -ForegroundColor Yellow
    scoop bucket add extras | Out-Null
    scoop install wezterm
} else {
    Write-Host "WezTerm ya está instalado." -ForegroundColor Green
}

if (-not (Get-Command "starship" -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Starship silenciosamente..." -ForegroundColor Yellow
    scoop install starship
} else {
    Write-Host "Starship ya está instalado." -ForegroundColor Green
}

# Configurar Starship en el perfil de PowerShell
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    New-Item -Path $profilePath -Type File -Force | Out-Null
}
$profileContent = Get-Content $profilePath -Raw
if (-not ($profileContent -match "starship init powershell")) {
    Write-Host "Configurando Starship en tu perfil de PowerShell..." -ForegroundColor Yellow
    Add-Content -Path $profilePath -Value "`nInvoke-Expression (&starship init powershell)" -Force
}

$userProfile = [System.Environment]::GetFolderPath("UserProfile")

# Helper functions
function Save-Backup {
    param ([string]$TargetPath)
    if (Test-Path $TargetPath) {
        $item = Get-Item $TargetPath -Force
        if ($item.Attributes -match "ReparsePoint") {
            Write-Host "Removiendo symlink existente: $TargetPath" -ForegroundColor Yellow
            Remove-Item -Path $TargetPath -Force -Recurse
            return
        }
        $timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
        $backupPath = "$TargetPath.bak_$timestamp"
        Write-Host "Creando backup de configuración existente: $backupPath" -ForegroundColor Cyan
        Move-Item -Path $TargetPath -Destination $backupPath -Force
    }
}

function Create-Symlink {
    param (
        [string]$SourcePath,
        [string]$DestinationPath,
        [string]$Type
    )
    $parentDir = Split-Path $DestinationPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    Save-Backup -TargetPath $DestinationPath
    Write-Host "Creando symlink: $DestinationPath -> $SourcePath" -ForegroundColor Green
    try {
        New-Item -ItemType SymbolicLink -Path $DestinationPath -Value $SourcePath -ErrorAction Stop | Out-Null
    } catch {
        Write-Host "CRITICAL ERROR: Falló al crear symlink en $DestinationPath" -ForegroundColor Red
        Write-Host "Detalles: $_" -ForegroundColor DarkRed
        Exit 1
    }
}

# 4. Auto-Discovery Logic
$pathsFile = Join-Path $repoRoot "custom_paths.json"
$customPaths = @{}

if (Test-Path $pathsFile) {
    try {
        $customPaths = Get-Content $pathsFile | ConvertFrom-Json -AsHashtable
    } catch {
        $customPaths = @{}
    }
}

function Get-Or-Find-Path {
    param ([string]$AgentKey, [string]$TargetFilter, [string]$DefaultPath)
    
    if ($customPaths.ContainsKey($AgentKey) -and (Test-Path $customPaths[$AgentKey])) {
        return $customPaths[$AgentKey]
    }
    
    if (Test-Path $DefaultPath) {
        $customPaths[$AgentKey] = $DefaultPath
        return $DefaultPath
    }
    
    Write-Host "Buscando ruta custom para $AgentKey ($TargetFilter)..." -ForegroundColor Yellow
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -notmatch "^[A-B]:" }
    foreach ($drive in $drives) {
        Write-Host "  Escaneando $($drive.Root) ..." -NoNewline
        $found = Get-ChildItem -Path $drive.Root -Recurse -Filter $TargetFilter -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            Write-Host " Encontrado: $($found.FullName)" -ForegroundColor Green
            $customPaths[$AgentKey] = $found.FullName
            return $found.FullName
        }
        Write-Host " Nada."
    }
    
    Write-Host "No se encontró $AgentKey. Usando ruta por defecto: $DefaultPath" -ForegroundColor Magenta
    $customPaths[$AgentKey] = $DefaultPath
    return $DefaultPath
}

Write-Host "`n=== TaoTomate.Dots Agent Configuration Installer ===" -ForegroundColor Green

# 5. Locate Agents
$geminiBase = Get-Or-Find-Path -AgentKey "Antigravity" -TargetFilter ".gemini" -DefaultPath (Join-Path $userProfile ".gemini")
$claudeBase = Get-Or-Find-Path -AgentKey "Claude" -TargetFilter ".clauderules" -DefaultPath (Join-Path $userProfile ".clauderules")
$openCodeBase = Get-Or-Find-Path -AgentKey "OpenCode" -TargetFilter "opencode" -DefaultPath (Join-Path $userProfile ".config\opencode")
$hermesBase = Get-Or-Find-Path -AgentKey "Hermes" -TargetFilter ".hermes" -DefaultPath (Join-Path $userProfile ".hermes")

# Save paths for next time
$customPaths | ConvertTo-Json | Set-Content $pathsFile

# Normalize base paths (if file found, get directory)
$geminiDir = if (Test-Path $geminiBase -PathType Leaf) { Split-Path $geminiBase -Parent } else { $geminiBase }
$claudeDir = if (Test-Path $claudeBase -PathType Leaf) { Split-Path $claudeBase -Parent } else { $claudeBase }
$opencodeDir = if (Test-Path $openCodeBase -PathType Leaf) { Split-Path $openCodeBase -Parent } else { $openCodeBase }
$hermesDir = if (Test-Path $hermesBase -PathType Leaf) { Split-Path $hermesBase -Parent } else { $hermesBase }

# 6. Apply Configurations
$agentsFileSource = Join-Path $repoRoot "agent-config\shared\agents.md"
$skillsSourceRoot = Join-Path $repoRoot "agent-config\skills"

# Antigravity
$geminiSkillsDest = Join-Path $geminiDir "config\skills"
$sharedSource = Join-Path $repoRoot "agent-config\shared"
$sharedDest = Join-Path $geminiSkillsDest "_shared"
Create-Symlink -SourcePath $sharedSource -DestinationPath $sharedDest -Type "Directory"

if (Test-Path $skillsSourceRoot) {
    Get-ChildItem -Directory -Path $skillsSourceRoot | ForEach-Object {
        $destPath = Join-Path $geminiSkillsDest $_.Name
        Create-Symlink -SourcePath $_.FullName -DestinationPath $destPath -Type "Directory"
    }
}

# Claude Code
$clauderulesDest = Join-Path $claudeDir ".clauderules"
Create-Symlink -SourcePath $agentsFileSource -DestinationPath $clauderulesDest -Type "File"

# OpenCode
$opencodeDest = Join-Path $opencodeDir "AGENTS.md"
Create-Symlink -SourcePath $agentsFileSource -DestinationPath $opencodeDest -Type "File"

# Hermes Agent
$hermesSoulDest = Join-Path $hermesDir "SOUL.md"
Create-Symlink -SourcePath $agentsFileSource -DestinationPath $hermesSoulDest -Type "File"

$hermesSkillsDest = Join-Path $hermesDir "skills"
if (Test-Path $skillsSourceRoot) {
    Get-ChildItem -Directory -Path $skillsSourceRoot | ForEach-Object {
        $destPath = Join-Path $hermesSkillsDest $_.Name
        Create-Symlink -SourcePath $_.FullName -DestinationPath $destPath -Type "Directory"
    }
}

# 7. Configure WezTerm & Starship
$weztermDest = Join-Path $userProfile ".wezterm.lua"
$weztermSource = Join-Path $repoRoot ".wezterm.lua"
Create-Symlink -SourcePath $weztermSource -DestinationPath $weztermDest -Type "File"

$starshipDest = Join-Path $userProfile ".config\starship.toml"
$starshipSource = Join-Path $repoRoot "starship.toml"
Create-Symlink -SourcePath $starshipSource -DestinationPath $starshipDest -Type "File"

Write-Host "`n¡Sincronización de Symlinks y Dependencias completada exitosamente!" -ForegroundColor Green

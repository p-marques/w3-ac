#requires -Version 5.1
<#
Creates a game-root ZIP from the existing runtime assets under src.
VERSION controls the archive name; this script never regenerates source files.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-StreamHash {
    param([System.IO.Stream] $Stream)

    $hasher = [System.Security.Cryptography.SHA256]::Create()
    try {
        return [System.BitConverter]::ToString($hasher.ComputeHash($Stream))
    }
    finally {
        $hasher.Dispose()
    }
}

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$sourceRoot = Join-Path $repositoryRoot 'src'
$versionPath = Join-Path $repositoryRoot 'VERSION'
if (-not (Test-Path -LiteralPath $versionPath -PathType Leaf)) {
    throw "Missing version file: $versionPath"
}
$version = [System.IO.File]::ReadAllText($versionPath).Trim()
if ($version -cnotmatch '^[0-9]+\.[0-9]+(?:\.[0-9]+)?(?:-beta)?$') {
    throw 'VERSION must contain major.minor or major.minor.patch, optionally followed by -beta (for example, 5.1-beta).'
}

# Explicit runtime allowlists exclude obsolete replacements and development files.
$mainPaths = @(
    'mods/modAbsoluteCamera/content/scripts/local/ACIntegrations.ws'
    'mods/modAbsoluteCamera/content/scripts/local/CACameraManager.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetAim.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetClue.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetCombat.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetCombatLockedToTarget.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetExploration.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetFistsCombat.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetHorseRiding.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetHorseRidingCombat.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetInteriors.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetMeditation.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetSailing.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetSigns.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetSprint.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetSwimming.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetWitcherSenses.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetWitcherSensesHorse.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetWitcherSensesInteriors.ws'
    'mods/modAbsoluteCamera/content/scripts/local/Presets/ACPresetWitcherSensesSwimming.ws'
    'mods/modAbsoluteCamera/content/scripts/local/SACamera.ws'
    'mods/modAbsoluteCamera/content/scripts/local/SAPresetCamera.ws'
    'bin/config/r4game/user_config_matrix/pc/modAbsoluteCameraMenu.xml'
    'mods/modAbsoluteCamera/content/ar.w3strings'
    'mods/modAbsoluteCamera/content/br.w3strings'
    'mods/modAbsoluteCamera/content/cn.w3strings'
    'mods/modAbsoluteCamera/content/cz.w3strings'
    'mods/modAbsoluteCamera/content/de.w3strings'
    'mods/modAbsoluteCamera/content/en.w3strings'
    'mods/modAbsoluteCamera/content/es.w3strings'
    'mods/modAbsoluteCamera/content/esMX.w3strings'
    'mods/modAbsoluteCamera/content/fr.w3strings'
    'mods/modAbsoluteCamera/content/hu.w3strings'
    'mods/modAbsoluteCamera/content/it.w3strings'
    'mods/modAbsoluteCamera/content/jp.w3strings'
    'mods/modAbsoluteCamera/content/kr.w3strings'
    'mods/modAbsoluteCamera/content/pl.w3strings'
    'mods/modAbsoluteCamera/content/ru.w3strings'
    'mods/modAbsoluteCamera/content/tr.w3strings'
    'mods/modAbsoluteCamera/content/ua.w3strings'
    'mods/modAbsoluteCamera/content/zh.w3strings'
)
$presetPaths = @(
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetAim.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetClue.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetCombat.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetCombatLockedToTarget.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetExploration.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetFistsCombat.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetHorseRiding.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetHorseRidingCombat.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetInteriors.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetMeditation.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetSailing.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetSigns.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetSprint.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetSwimming.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetWitcherSenses.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetWitcherSensesHorse.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetWitcherSensesInteriors.ws'
    'mods/mod0AbsoluteCamera_pMarK_Presets/content/scripts/local/Presets/ACPresetWitcherSensesSwimming.ws'
)
$patchPath = 'absolute_camera_input.settings_patch.txt'
$entryPaths = @($mainPaths) + @($presetPaths) + @($patchPath)
# Read and hash every required file before touching an existing release archive.
$inputs = @{}
foreach ($entryPath in $entryPaths) {
    $sourcePath = Join-Path $sourceRoot $entryPath
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
        throw "Missing required release file: $sourcePath"
    }
    $stream = [System.IO.File]::OpenRead($sourcePath)
    try {
        if ($stream.Length -eq 0) {
            throw "Required release file is empty: $sourcePath"
        }
        $inputs[$entryPath] = [PSCustomObject]@{
            SourcePath = $sourcePath
            EntryPath = $entryPath
            Length = $stream.Length
            Hash = Get-StreamHash -Stream $stream
        }
    }
    finally {
        $stream.Dispose()
    }
}

function New-VerifiedArchive {
    param([string[]] $entryPaths, [string] $temporaryArchive)
    $archiveStream = [System.IO.File]::Open(
        $temporaryArchive, [System.IO.FileMode]::CreateNew,
        [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
    try {
        $archive = [System.IO.Compression.ZipArchive]::new(
            $archiveStream, [System.IO.Compression.ZipArchiveMode]::Create, $true)
        try {
            foreach ($entryPath in ($entryPaths | Sort-Object)) {
                $entry = $archive.CreateEntry($entryPath, [System.IO.Compression.CompressionLevel]::Optimal)
                $sourceStream = [System.IO.File]::OpenRead($inputs[$entryPath].SourcePath)
                try {
                    $entryStream = $entry.Open()
                    try {
                        $sourceStream.CopyTo($entryStream)
                    }
                    finally {
                        $entryStream.Dispose()
                    }
                }
                finally {
                    $sourceStream.Dispose()
                }
            }
        }
        finally {
            $archive.Dispose()
        }
    }
    finally {
        $archiveStream.Dispose()
    }

    # Validate the finished ZIP's contents, including decompression and source hashes.
    $archive = [System.IO.Compression.ZipFile]::OpenRead($temporaryArchive)
    try {
        if ($archive.Entries.Count -ne $entryPaths.Count) {
            throw 'Release verification failed: unexpected entry count.'
        }
        $seen = @{}
        foreach ($entry in $archive.Entries) {
            if (-not ($entryPaths -ccontains $entry.FullName) -or $seen.ContainsKey($entry.FullName)) {
                throw "Release verification failed: unexpected or duplicate entry '$($entry.FullName)'."
            }
            $expected = $inputs[$entry.FullName]
            if ($entry.FullName -cne $expected.EntryPath -or $entry.Length -ne $expected.Length) {
                throw "Release verification failed: path or length mismatch for '$($entry.FullName)'."
            }
            $entryStream = $entry.Open()
            try {
                if ((Get-StreamHash -Stream $entryStream) -cne $expected.Hash) {
                    throw "Release verification failed: content mismatch for '$($entry.FullName)'."
                }
            }
            finally {
                $entryStream.Dispose()
            }
            $seen[$entry.FullName] = $true
        }
    }
    finally {
        $archive.Dispose()
    }

}

$outputDirectory = Join-Path $repositoryRoot 'dist'
[System.IO.Directory]::CreateDirectory($outputDirectory) | Out-Null
$outputs = @(
    [PSCustomObject]@{ Name = "AbsoluteCamera-v$version.zip"; Entries = $mainPaths },
    [PSCustomObject]@{ Name = "AbsoluteCamera-pMarK-Presets-v$version.zip"; Entries = $presetPaths },
    [PSCustomObject]@{ Name = $patchPath; Entries = @() }
)
$transaction = [guid]::NewGuid().ToString('N')
$artifacts = @()
$completed = @()
try {
    # Verify every staged output before replacing any existing artifact.
    foreach ($output in $outputs) {
        $artifact = [PSCustomObject]@{
            Target = Join-Path $outputDirectory $output.Name
            Temp = Join-Path $outputDirectory ('.build-' + $transaction + '-' + $output.Name)
            Backup = Join-Path $outputDirectory ('.backup-' + $transaction + '-' + $output.Name)
            Existed = [System.IO.File]::Exists((Join-Path $outputDirectory $output.Name))
        }
        $artifacts += $artifact
        if ($output.Entries.Count -gt 0) {
            New-VerifiedArchive -entryPaths $output.Entries -temporaryArchive $artifact.Temp
        }
        else {
            [System.IO.File]::Copy($inputs[$patchPath].SourcePath, $artifact.Temp)
            $stream = [System.IO.File]::OpenRead($artifact.Temp)
            try {
                if ($stream.Length -ne $inputs[$patchPath].Length -or
                    (Get-StreamHash $stream) -cne $inputs[$patchPath].Hash) {
                    throw 'Input patch verification failed.'
                }
            }
            finally { $stream.Dispose() }
        }
    }
    try {
        foreach ($artifact in $artifacts) {
            if ($artifact.Existed) {
                [System.IO.File]::Replace($artifact.Temp, $artifact.Target, $artifact.Backup)
            }
            else {
                [System.IO.File]::Move($artifact.Temp, $artifact.Target)
            }
            $completed += $artifact
        }
    }
    catch {
        $publicationError = $_
        # Roll back earlier replacements if a later output cannot be published.
        # If recovery itself fails, retain backups for manual recovery.
        for ($i = $completed.Count - 1; $i -ge 0; $i--) {
            $artifact = $completed[$i]
            if ($artifact.Existed) {
                [System.IO.File]::Replace($artifact.Backup, $artifact.Target, [NullString]::Value)
            }
            else { [System.IO.File]::Delete($artifact.Target) }
        }
        throw $publicationError
    }
    foreach ($artifact in $artifacts) {
        if ([System.IO.File]::Exists($artifact.Backup)) { [System.IO.File]::Delete($artifact.Backup) }
        Write-Output "Created $($artifact.Target)"
    }
}
finally {
    foreach ($artifact in $artifacts) {
        if ([System.IO.File]::Exists($artifact.Temp)) { [System.IO.File]::Delete($artifact.Temp) }
    }
}

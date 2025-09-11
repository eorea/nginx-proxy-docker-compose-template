#!/usr/bin/env pwsh

param([string]$dotenvfile='.\.env')
if (-Not (Test-Path $dotenvfile)) {
    Write-Error "File $dotenvfile not found"
    exit 1
}

foreach($line in Get-Content $dotenvfile) {
    if ($line -match '^\s*#') { continue } # skip comments
    if ($line -notmatch '=') { continue } # skip lines without '='
    if ($line -match '^\s*$') { continue } # skip empty lines

    $EnvVarName = $line -split '=' | select -First 1 | ForEach-Object { $_.Trim() }
    $EnvVarValue = $line -split "${EnvVarName}=" | select -Last 1 | ForEach-Object { $_.Trim() }

    [Environment]::SetEnvironmentVariable($EnvVarName, $EnvVarValue)
}

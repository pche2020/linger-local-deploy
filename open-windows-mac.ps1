#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9_.-]{0,252}\z')]
    [string]$SshHost,

    [Parameter(Mandatory)]
    [ValidateRange(1, 65535)]
    [int]$MacWebPort
)

$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT') { throw 'Run this script on the Windows client.' }
$ssh = Get-Command ssh.exe -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $ssh) { throw 'Install Windows OpenSSH Client or use your existing approved SSH client.' }

$forward = '127.0.0.1:{0}:127.0.0.1:{0}' -f $MacWebPort
Write-Host "When SSH connects, open http://localhost:$MacWebPort in Windows."
Write-Host 'Keep this window open while using the tunnel. Press Ctrl+C to stop it.'
& $ssh.Source -N -T -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -L $forward -- $SshHost
exit $LASTEXITCODE

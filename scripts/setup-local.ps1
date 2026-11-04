$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $root '.env'
if (Test-Path -LiteralPath $envFile) {
    Write-Output '.env existente preservado.'
    exit 0
}
function New-LocalToken {
    $bytes = New-Object byte[] 32
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try { $rng.GetBytes($bytes) } finally { $rng.Dispose() }
    return [BitConverter]::ToString($bytes).Replace('-', '').ToLowerInvariant()
}
$content = @(
    '# Apenas para o ambiente Docker local. Nunca versionar.'
    "POSTGRES_PASSWORD=$(New-LocalToken)"
    "MASTER_KEY=$(New-LocalToken)"
    "SERVICE_API_KEY=tm_key_$(New-LocalToken)"
)
[IO.File]::WriteAllLines($envFile, $content, (New-Object Text.UTF8Encoding($false)))
Write-Output '.env local criado; valores omitidos.'

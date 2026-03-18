# Export all Dart code to a single file
# Run from bloomp project root

$ErrorActionPreference = "Stop"
$projectRoot = $PSScriptRoot
$outputFile = Join-Path $projectRoot "FULL_CODE_EXPORT.txt"

# Remove existing output file if it exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
}

# 1. Include pubspec.yaml first
$pubspecPath = Join-Path $projectRoot "pubspec.yaml"
if (Test-Path $pubspecPath) {
    Add-Content -Path $outputFile -Value "=== pubspec.yaml ==="
    Add-Content -Path $outputFile -Value (Get-Content -Path $pubspecPath -Raw)
    Add-Content -Path $outputFile -Value ""
}

# 2. Get all .dart files in lib/ recursively, sorted for consistent order
$dartFiles = Get-ChildItem -Path (Join-Path $projectRoot "lib") -Filter "*.dart" -Recurse | Sort-Object FullName

foreach ($file in $dartFiles) {
    $relativePath = $file.FullName.Substring($projectRoot.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar)
    $relativePath = $relativePath.Replace([char]92, '/')

    Add-Content -Path $outputFile -Value "=== $relativePath ==="
    Add-Content -Path $outputFile -Value (Get-Content -Path $file.FullName -Raw)
    Add-Content -Path $outputFile -Value ""
}

Write-Host "Export complete: $outputFile"

$exportFile = "D:\Aza\bloomp\FULL_CODE_EXPORT.txt"
$baseDir = "D:\Aza\bloomp"

$content = Get-Content $exportFile -Raw -Encoding UTF8

# Split by "=== lib/" or "=== lib\"
$sections = $content -split '=== lib[/\\]'

foreach ($section in $sections) {
    if ([string]::IsNullOrWhiteSpace($section)) { continue }

    # Section starts with "path/to/file.dart ===" or "path\to\file.dart ==="
    if ($section -notmatch '^([^\r\n]+?)\s*===\s*[\r\n]') { continue }
    $relativePath = $matches[1].Trim() -replace '\\', '/'
    $relativePath = $relativePath -replace '^=+\s*lib[/\\]', ''
    if ($relativePath -notmatch '\.dart$') { continue }

    $newlinePos = $section.IndexOf("`n")
    if ($newlinePos -lt 0) { $newlinePos = $section.IndexOf("`r") }
    if ($newlinePos -lt 0) { continue }
    $code = if ($section[$newlinePos] -eq "`r" -and $section.Length -gt $newlinePos + 1 -and $section[$newlinePos + 1] -eq "`n") { $section.Substring($newlinePos + 2) } else { $section.Substring($newlinePos + 1) }

    $nextMatch = [regex]::Match($code, '[\r\n]+\s*=== ')
    if ($nextMatch.Success) { $code = $code.Substring(0, $nextMatch.Index) }

    $fullPath = Join-Path (Join-Path $baseDir "lib") $relativePath
    $dir = Split-Path $fullPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($fullPath, $code.TrimEnd(), $utf8NoBom)
    Write-Host "Restored: lib/$relativePath"
}
Write-Host "Done."

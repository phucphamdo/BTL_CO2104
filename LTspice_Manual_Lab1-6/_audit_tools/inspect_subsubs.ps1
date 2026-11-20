for ($lab = 1; $lab -le 6; $lab++) {
    $file = "LTspice_Manual_Lab1-6\lab$lab.tex"
    $lines = Get-Content $file -Encoding utf8
    $subsubs = $lines | Where-Object { $_ -match '\\subsubsection\{([^}]+)\}' }
    $tables = $lines | Where-Object { $_ -match '\\begin\{(tabular|tabularx)\}' }
    $imgs = $lines | Where-Object { $_ -match '\\includegraphics' }
    Write-Output "=== Lab $lab ==="
    Write-Output "  Total subsubsections: $($subsubs.Count)"
    Write-Output "  Sample subsubsections:"
    ($subsubs | Select-Object -First 6) | ForEach-Object { "    $_" }
    Write-Output "  Total tables: $($tables.Count)"
    Write-Output "  Total images: $($imgs.Count)"
}

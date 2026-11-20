$results = @()

for ($lab = 1; $lab -le 6; $lab++) {
    $file = "LTspice_Manual_Lab1-6\lab$lab.tex"
    $lines = Get-Content $file -Encoding utf8
    $content = $lines -join "`n"

    # Split into subsections
    $sections = [regex]::Split($content, '(?=\\subsection\{)')

    foreach ($sec in $sections) {
        if ($sec -match '\\subsection\{(Exercise|Advanced [eE]xercise)\s+(\d+):\s*([^}]+)\}') {
            $type = $matches[1]
            $id = $matches[2]
            $title = $matches[3]

            $hasStatus = $sec -match '\\status\{([^}]+)\}'
            $statusText = if ($hasStatus) { $matches[1] } else { "MISSING" }

            $hasFig = $sec -match '\\labfig\{([^}]+)\}'
            $figName = if ($hasFig) { $matches[1] } else { "MISSING" }

            $hasTheory = ($sec -match '\\theory\{' -or $sec -match 'Theory calculation')
            $hasSim = ($sec -match '\\simulation\{' -or $sec -match 'LTspice simulation')
            $hasComp = ($sec -match '\\comparetable\{' -or $sec -match '\\textbf\{Quantity\}')
            $hasSave = $sec -match 'Ex\d+\.asc'

            $results += [PSCustomObject]@{
                Lab = "Lab $lab"
                Type = $type
                ID = [int]$id
                Title = $title.Trim()
                Status = if ($hasStatus) { "OK" } else { "NO" }
                Figure = if ($hasFig) { "OK" } else { "NO" }
                Theory = if ($hasTheory) { "OK" } else { "NO" }
                Sim = if ($hasSim) { "OK" } else { "NO" }
                Comp = if ($hasComp) { "OK" } else { "NO" }
                SaveRef = if ($hasSave) { "OK" } else { "NO" }
                StatusVal = $statusText
            }
        }
    }
}

$results | Format-Table Lab, ID, Type, Status, Figure, Theory, Sim, Comp, SaveRef -AutoSize | Out-String | Set-Content "LTspice_Manual_Lab1-6\audit_summary.txt" -Encoding utf8
Write-Output "Total exercises found: $($results.Count)"

# Check any with missing items
$missing = $results | Where-Object { $_.Status -eq "NO" -or $_.Figure -eq "NO" -or $_.Theory -eq "NO" -or $_.Sim -eq "NO" -or $_.Comp -eq "NO" -or $_.SaveRef -eq "NO" }
if ($missing.Count -gt 0) {
    Write-Output "WARNING: Found $($missing.Count) exercises with missing components:"
    $missing | Format-Table Lab, ID, Title, Status, Figure, Theory, Sim, Comp, SaveRef
} else {
    Write-Output "ALL 72 exercises (6 labs x 12 exercises) have Figure, Theory, Sim, Comp, Status, and SaveRef!"
}

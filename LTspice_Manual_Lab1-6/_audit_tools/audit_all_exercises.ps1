for ($lab = 1; $lab -le 6; $lab++) {
    $file = "LTspice_Manual_Lab1-6\lab$lab.tex"
    $lines = Get-Content $file -Encoding utf8
    Write-Output "=========================================================="
    Write-Output "LAB ${lab}: EXERCISE AUDIT"
    Write-Output "=========================================================="
    $exCount = 0
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '\\subsection\{((Exercise|Advanced [eE]xercise)\s+\d+:\s*[^}]+)\}') {
            $exCount++
            $title = $matches[1]
            $status = ""
            for ($j = $i + 1; $j -le [Math]::Min($i + 5, $lines.Count - 1); $j++) {
                if ($lines[$j] -match '\\status\{([^}]+)\}') {
                    $status = $matches[1]
                    break
                }
            }
            Write-Output "  [$exCount] $title"
            Write-Output "       -> Status: $status"
        }
    }
}

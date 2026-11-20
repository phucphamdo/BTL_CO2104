for ($lab = 1; $lab -le 6; $lab++) {
    $file = "LTspice_Manual_Lab1-6\lab$lab.tex"
    $content = Get-Content $file -Raw -Encoding utf8
    $exMatches = [regex]::Matches($content, '\\subsection\{Exercise\s+(\d+)')
    $advMatches = [regex]::Matches($content, '\\subsection\{Advanced [eE]xercise\s+(\d+)')
    $statusMatches = [regex]::Matches($content, '\\status\{([^}]+)\}')
    $theoryCount = ([regex]::Matches($content, 'Theory calculation')).Count
    $simCount = ([regex]::Matches($content, 'LTspice simulation')).Count
    $compCount = ([regex]::Matches($content, 'Comparison')).Count
    $imgs = ([regex]::Matches($content, '\\includegraphics')).Count
    $saveCount = ([regex]::Matches($content, 'Ex\d+\.asc')).Count
    
    $exList = ($exMatches | ForEach-Object { $_.Groups[1].Value }) -join ', '
    $advList = ($advMatches | ForEach-Object { $_.Groups[1].Value }) -join ', '
    $statusList = ($statusMatches | ForEach-Object { $_.Groups[1].Value }) -join ', '

    Write-Output "=== Lab $lab ==="
    Write-Output "  Main Exercises ($($exMatches.Count)): $exList"
    Write-Output "  Advanced Exercises ($($advMatches.Count)): $advList"
    Write-Output "  Status tags ($($statusMatches.Count)): $statusList"
    Write-Output "  Theory: $theoryCount | Sim: $simCount | Comp: $compCount | Images: $imgs | ExXX.asc refs: $saveCount"
}

$advs = @(
    @{ Lab = 2; Adv = 1; File = "LTspice_Manual_Lab1-6\lab2.tex" },
    @{ Lab = 2; Adv = 2; File = "LTspice_Manual_Lab1-6\lab2.tex" },
    @{ Lab = 3; Adv = 1; File = "LTspice_Manual_Lab1-6\lab3.tex" },
    @{ Lab = 4; Adv = 1; File = "LTspice_Manual_Lab1-6\lab4.tex" },
    @{ Lab = 5; Adv = 1; File = "LTspice_Manual_Lab1-6\lab5.tex" }
)

foreach ($item in $advs) {
    $c = Get-Content $item.File -Raw -Encoding utf8
    $pattern = "(?s)\\subsection\{Advanced [eE]xercise " + $item.Adv + ":.*?(?=(\\subsection|\\newpage|\\section|\Z))"
    if ($c -match $pattern) {
        $sec = $matches[0]
        $hasTab = $sec -match '\\begin\{(tabular|tabularx)\}'
        Write-Output "Lab $($item.Lab) Adv $($item.Adv) has table: $hasTab"
        if ($sec -match '\\begin\{(tabular|tabularx)\}.*?\\end\{\1\}') {
            Write-Output "Table snippet:"
            Write-Output $matches[0]
        }
    }
}

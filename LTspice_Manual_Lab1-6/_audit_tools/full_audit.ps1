# =============================================================================
# full_audit.ps1 — Kiểm tra toàn diện LTspice Manual Lab1-6
# So sánh yêu cầu giáo viên (CO2037_docx) vs file lab mới (lab1-6.tex)
# Chạy từ: LTspice_Manual_Lab1-6\_audit_tools\
#   cd _audit_tools ; .\full_audit.ps1
# =============================================================================

$Root      = Split-Path $PSScriptRoot -Parent          # …/LTspice_Manual_Lab1-6
$ToolsDir  = $PSScriptRoot
$ReportOut = Join-Path $ToolsDir "full_audit_report.md"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# ── Màu helper ────────────────────────────────────────────────────────────────
function OK   { param($msg) Write-Host "  [OK]  $msg" -ForegroundColor Green  }
function WARN { param($msg) Write-Host "  [!!]  $msg" -ForegroundColor Yellow }
function FAIL { param($msg) Write-Host "  [XX]  $msg" -ForegroundColor Red    }
function HEAD { param($msg) Write-Host "`n=== $msg ===" -ForegroundColor Cyan  }

# ── Yêu cầu giáo viên (trích từ CO2037_Project3) ─────────────────────────────
# Mỗi lab: số bài tập chính, số bài nâng cao, trạng thái mong đợi
$TeacherSpec = @{
    1 = @{ ExCount=10; AdvCount=2; Chapter="Ch.1 First Project on PSpice";   Topic="DC/Resistive circuits" }
    2 = @{ ExCount=10; AdvCount=2; Chapter="Ch.2 Diode Circuits";             Topic="Diode analysis" }
    3 = @{ ExCount=10; AdvCount=2; Chapter="Ch.3 BJT";                        Topic="BJT circuits" }
    4 = @{ ExCount=10; AdvCount=2; Chapter="Ch.5 Op-amp";                     Topic="Op-amp" }
    5 = @{ ExCount=10; AdvCount=2; Chapter="Ch.6 FET";                        Topic="FET/MOSFET" }
    6 = @{ ExCount=10; AdvCount=2; Chapter="Ch.7 24-Hour Project (Midterm)";  Topic="Mixed circuits" }
}

# Trạng thái hợp lệ theo yêu cầu đề bài
$ValidStatuses = @("Unchanged", "Modified", "Replaced", "Giữ nguyên", "Điều chỉnh", "Thay thế",
                   "Nâng cao", "Bổ sung", "direct transfer", "Advanced", "Supplementary")

# Lệnh SPICE hợp lệ
$ValidSpice = @("\.op", "\.dc", "\.tran", "\.ac", "\.step", "\.param", "\.meas", "\.tf", "\.noise", "\.temp", "mc\(")

# ── Bảng kết quả tổng hợp ─────────────────────────────────────────────────────
$AllResults = @()
$Warnings   = @()
$Errors     = @()

HEAD "FULL AUDIT — LTspice Manual Lab1-6"
Write-Host "Thời gian: $Timestamp"
Write-Host "Thư mục gốc: $Root"

# =============================================================================
# PHẦN 1: KIỂM TRA CẤU TRÚC FILE .TEX
# =============================================================================
HEAD "PHẦN 1: Cấu trúc file .tex (6 lab)"

$TexSummary = @()
for ($lab = 1; $lab -le 6; $lab++) {
    $texFile = Join-Path $Root "tex\lab$lab.tex"
    if (-not (Test-Path $texFile)) { $texFile = Join-Path $Root "lab$lab.tex" }
    $spec    = $TeacherSpec[$lab]

    if (-not (Test-Path $texFile)) {
        FAIL "lab$lab.tex KHÔNG TỒN TẠI (cả trong tex\ lẫn root)!"
        $Errors += "Lab $lab`: File lab$lab.tex bị thiếu"
        continue
    }

    $content = Get-Content $texFile -Raw -Encoding utf8

    # --- Đếm bài tập ---
    $exMatches  = [regex]::Matches($content, '\\subsection\{Exercise\s+(\d+)[^}]*\}')
    $advMatches = [regex]::Matches($content, '\\subsection\{Advanced\s+[eE]xercise\s+(\d+)[^}]*\}')
    $exCount    = $exMatches.Count
    $advCount   = $advMatches.Count

    # --- Kiểm tra status tag ---
    $statusMatches  = [regex]::Matches($content, '\\status\{([^}]+)\}')
    $statusCount    = $statusMatches.Count
    $expectedStatus = $spec.ExCount + $spec.AdvCount   # 12 mỗi lab
    $invalidStatuses = @()
    foreach ($sm in $statusMatches) {
        $stVal = $sm.Groups[1].Value.Trim()
        $isValid = $false
        foreach ($p in $ValidStatuses) {
            if ($stVal -match [regex]::Escape($p)) { $isValid = $true; break }
        }
        if (-not $isValid) { $invalidStatuses += $stVal }
    }

    # --- Kiểm tra các thành phần cấu trúc từng bài ---
    $secBlocks = [regex]::Split($content, '(?=\\subsection\{(?:Exercise|Advanced\s+[eE]xercise)\s+\d+:)')
    $theoryMainCount = 0; $compMainCount = 0; $theoryAdvCount = 0; $compAdvCount = 0
    foreach ($sec in $secBlocks) {
        if ($sec -match '\\subsection\{Exercise\s+\d+:') {
            if ($sec -match '\\theory\{|\\subsubsection\{Theory') { $theoryMainCount++ }
            if ($sec -match '\\comparetable\{|\\begin\{tabular') { $compMainCount++ }
        } elseif ($sec -match '\\subsection\{Advanced\s+[eE]xercise\s+\d+:') {
            if ($sec -match '\\theory\{|\\subsubsection\{Theory') { $theoryAdvCount++ }
            if ($sec -match '\\comparetable\{|\\begin\{tabular') { $compAdvCount++ }
        }
    }
    $theoryCount = $theoryMainCount + $theoryAdvCount
    $simCount    = ([regex]::Matches($content, '\\simulation\{')).Count
    $compCount   = $compMainCount + $compAdvCount
    $figCount    = ([regex]::Matches($content, '\\labfig\{')).Count
    $imgCount    = ([regex]::Matches($content, '\\includegraphics')).Count

    # --- Kiểm tra file .asc references ---
    $ascRefs      = [regex]::Matches($content, 'Lab' + $lab + '/Ex\d+\.asc')
    $ascWrongCase = [regex]::Matches($content, 'LAB' + $lab + '/')  # sai viết hoa
    $ascWrongNum  = [regex]::Matches($content, 'Labl/')  # l thay vì 1

    # --- Kiểm tra lệnh SPICE ---
    $spiceFound = @()
    foreach ($cmd in $ValidSpice) {
        if ($content -match $cmd) { $spiceFound += $cmd.Replace('\','').Replace('(','') }
    }

    # --- So sánh với yêu cầu giáo viên ---
    $exOK  = ($exCount  -eq $spec.ExCount)
    $advOK = ($advCount -eq $spec.AdvCount)
    $stOK  = ($statusCount -ge $expectedStatus)

    $row = [PSCustomObject]@{
        Lab          = "Lab $lab"
        Chapter      = $spec.Chapter
        ExReq        = $spec.ExCount
        ExFound      = $exCount
        ExOK         = if($exOK) {"✓"} else {"✗"}
        AdvReq       = $spec.AdvCount
        AdvFound     = $advCount
        AdvOK        = if($advOK) {"✓"} else {"✗"}
        StatusReq    = $expectedStatus
        StatusFound  = $statusCount
        StatusOK     = if($stOK) {"✓"} else {"✗"}
        Theory       = $theoryCount
        Sim          = $simCount
        CompTable    = $compCount
        Figures      = $figCount
        Images       = $imgCount
        AscRefs      = $ascRefs.Count
        SpiceCmds    = ($spiceFound -join ", ")
        AscBadPath   = $ascWrongNum.Count
    }
    $TexSummary += $row
    $AllResults += $row

    # Báo cáo ngay
    if ($exOK -and $advOK -and $stOK) {
        OK "Lab ${lab}: Bài tập $exCount/$($spec.ExCount) ✓ | Nâng cao $advCount/$($spec.AdvCount) ✓ | Status $statusCount/$expectedStatus ✓ | Theory $theoryCount/$expectedStatus ✓ | Comp $compCount/$expectedStatus ✓"
    } else {
        if (-not $exOK)  { FAIL  "Lab ${lab}: Bài tập tìm được $exCount (yêu cầu $($spec.ExCount))";   $Errors += "Lab ${lab}: Thiếu bài tập chính ($exCount/$($spec.ExCount))" }
        if (-not $advOK) { WARN  "Lab ${lab}: Bài nâng cao $advCount (yêu cầu $($spec.AdvCount))";     $Warnings += "Lab ${lab}: Bài nâng cao $advCount/$($spec.AdvCount)" }
        if (-not $stOK)  { FAIL  "Lab ${lab}: Status tag $statusCount (yêu cầu $expectedStatus)";      $Errors += "Lab ${lab}: Thiếu \\status{} tag ($statusCount/$expectedStatus)" }
    }

    # Cảnh báo đường dẫn .asc sai
    if ($ascWrongNum.Count -gt 0) {
        WARN "Lab ${lab}: Phát hiện $($ascWrongNum.Count) chỗ 'Labl/' (l thường thay cho số 1)"
        $Warnings += "Lab ${lab}: $($ascWrongNum.Count) lần dùng 'Labl/' thay vì 'Lab1/'"
    }
    if ($ascWrongCase.Count -gt 0) {
        WARN "Lab ${lab}: Phát hiện $($ascWrongCase.Count) chỗ viết hoa sai 'LAB${lab}/'"
        $Warnings += "Lab ${lab}: $($ascWrongCase.Count) lần dùng 'LAB${lab}/' thay vì 'Lab${lab}/'"
    }

    # Cảnh báo status tag không hợp lệ
    if ($invalidStatuses.Count -gt 0) {
        WARN "Lab ${lab}: Phát hiện $($invalidStatuses.Count) status tag không chuẩn"
        $Warnings += "Lab ${lab}: Status tag không chuẩn ($($invalidStatuses -join '; '))"
    }

    # Theory/Sim/Comp phải khớp với số bài
    if ($theoryMainCount -lt $spec.ExCount) {
        WARN "Lab ${lab}: Thiếu Theory trong bài chính ($theoryMainCount/$($spec.ExCount))"
        $Warnings += "Lab ${lab}: Theory bài chính = $theoryMainCount (nên = $($spec.ExCount))"
    }
    if ($compMainCount -lt $spec.ExCount) {
        WARN "Lab ${lab}: Thiếu Comparison trong bài chính ($compMainCount/$($spec.ExCount))"
        $Warnings += "Lab ${lab}: Comp bài chính = $compMainCount (nên = $($spec.ExCount))"
    }
    if ($theoryAdvCount -lt $spec.AdvCount) {
        WARN "Lab ${lab}: Bài nâng cao thiếu Theory ($theoryAdvCount/$($spec.AdvCount))"
        $Warnings += "Lab ${lab}: AdvTheory = $theoryAdvCount (nên = $($spec.AdvCount))"
    }
}

# =============================================================================
# PHẦN 2: KIỂM TRA FILE .ASC (MÔ PHỎNG)
# =============================================================================
HEAD "PHẦN 2: File mô phỏng .asc trong sim\"

$SimSummary = @()
for ($lab = 1; $lab -le 6; $lab++) {
    $simDir = Join-Path $Root "sim\Lab$lab"
    $spec   = $TeacherSpec[$lab]
    $total  = $spec.ExCount + $spec.AdvCount  # 12 file

    if (-not (Test-Path $simDir)) {
        FAIL "sim\Lab${lab}\ KHÔNG TỒN TẠI!"
        $Errors += "Lab ${lab}: Thư mục sim\Lab${lab}\ bị thiếu"
        continue
    }

    $ascFiles = Get-ChildItem $simDir -Filter "*.asc" -ErrorAction SilentlyContinue
    $cirFiles = Get-ChildItem $simDir -Filter "*.cir" -ErrorAction SilentlyContinue
    $allSim   = @($ascFiles) + @($cirFiles)

    # Kiểm tra từng file Ex01..Ex12 (kể cả variant Ex01a, Ex01b, v.v.)
    $found    = @()
    $missing  = @()
    for ($ex = 1; $ex -le $total; $ex++) {
        $exName = "Ex{0:D2}" -f $ex
        # Tên chuẩn
        $hasAsc  = Test-Path (Join-Path $simDir "$exName.asc")
        $hasCir  = Test-Path (Join-Path $simDir "$exName.cir")
        # Variant: Ex01a, Ex01b hoặc (với Adv) Adv01 = Ex11, Adv02 = Ex12
        $advNum  = $ex - $spec.ExCount   # 1 hoặc 2 nếu ex > ExCount
        $hasAdv  = $false
        if ($advNum -ge 1 -and $advNum -le $spec.AdvCount) {
            $hasAdv = (Test-Path (Join-Path $simDir ("Adv{0:D2}.asc" -f $advNum))) -or
                      (Test-Path (Join-Path $simDir ("Adv{0:D2}.cir" -f $advNum)))
        }
        $hasVariant = (Get-ChildItem $simDir -Filter "${exName}*.asc" -ErrorAction SilentlyContinue).Count -gt 0 -or
                      (Get-ChildItem $simDir -Filter "${exName}*.cir" -ErrorAction SilentlyContinue).Count -gt 0
        if ($hasAsc -or $hasCir -or $hasAdv -or $hasVariant) { $found  += $exName }
        else                                                   { $missing += $exName }
    }

    $row = [PSCustomObject]@{
        Lab       = "Lab $lab"
        Dir       = "sim\Lab$lab"
        Required  = $total
        Found     = $found.Count
        Missing   = if($missing.Count -gt 0){ $missing -join ", " } else { "-" }
        ExtraASC  = ($allSim | Where-Object { $_.BaseName -notmatch "^(Ex|Adv)\d+" }).Count
    }
    $SimSummary += $row

    if ($missing.Count -eq 0) {
        OK "Lab ${lab}: $($found.Count)/$total file mô phỏng ✓"
    } else {
        WARN "Lab ${lab}: Thiếu $($missing.Count) file: $($missing -join ', ')"
        $Warnings += "Lab ${lab} sim: Thiếu file: $($missing -join ', ')"
    }
}

# =============================================================================
# PHẦN 3: KIỂM TRA YÊU CẦU GIÁO VIÊN (đề bài CO2037)
# =============================================================================
HEAD "PHẦN 3: Đối chiếu yêu cầu giáo viên"

Write-Host "`nYêu cầu bắt buộc theo đề bài CO2037 Dự án 3:"
$RequirementsCheck = @()

# R1: Mỗi lab có đúng 10 bài chính + 2 bài nâng cao
$r1Pass = ($TexSummary | Where-Object { $_.ExOK -eq "✓" -and $_.AdvOK -eq "✓" }).Count -eq 6
$RequirementsCheck += [PSCustomObject]@{ Req="R1"; Mô_tả="Mỗi lab: 10 bài chính + 2 nâng cao (6×12=72 tổng)"; Kết_quả=if($r1Pass){"✓ ĐẠT"}else{"✗ CHƯA ĐẠT"} }
if ($r1Pass) { OK "R1: Tổng 72 bài (6×12) ✓" } else { FAIL "R1: Chưa đủ 72 bài" }

# R2: Mỗi bài phải có \status{} tag
$r2Total = ($TexSummary | Measure-Object -Property StatusFound -Sum).Sum
$r2Req   = 72
$r2Pass  = ($r2Total -ge $r2Req)
$RequirementsCheck += [PSCustomObject]@{ Req="R2"; Mô_tả="Mỗi bài có \\status{} phân loại (Unchanged/Modified/Replaced)"; Kết_quả=if($r2Pass){"✓ ĐẠT ($r2Total/$r2Req)"}else{"✗ CHƯA ĐẠT ($r2Total/$r2Req)"} }
if ($r2Pass) { OK "R2: Status tags $r2Total/$r2Req ✓" } else { FAIL "R2: Thiếu status tag ($r2Total/$r2Req)" }

# R3: Mỗi bài có Theory + Simulation + Comparison (cấu trúc 4 phần)
$r3Theory = ($TexSummary | Measure-Object -Property Theory -Sum).Sum
$r3Sim    = ($TexSummary | Measure-Object -Property Sim -Sum).Sum
$r3Comp   = ($TexSummary | Measure-Object -Property CompTable -Sum).Sum
$r3Pass   = ($r3Theory -ge 72) -and ($r3Sim -ge 72) -and ($r3Comp -ge 72)
$RequirementsCheck += [PSCustomObject]@{ Req="R3"; Mô_tả="Cấu trúc bài: Theory + Simulation + Comparison table"; Kết_quả=if($r3Pass){"✓ ĐẠT (Theory=$r3Theory, Sim=$r3Sim, Comp=$r3Comp)"}else{"✗ CHƯA ĐẠT (Theory=$r3Theory, Sim=$r3Sim, Comp=$r3Comp)"} }
if ($r3Pass) { OK "R3: Cấu trúc 3 phần đầy đủ (72/72) ✓" } else { WARN "R3: Theory=$r3Theory Sim=$r3Sim Comp=$r3Comp" }

# R4: Có hình ảnh / labfig
$r4Figs  = ($TexSummary | Measure-Object -Property Figures -Sum).Sum
$r4Imgs  = ($TexSummary | Measure-Object -Property Images -Sum).Sum
$r4Pass  = ($r4Figs -ge 60)
$RequirementsCheck += [PSCustomObject]@{ Req="R4"; Mô_tả="Mỗi bài có hình circuit (\\labfig)"; Kết_quả="labfig=$r4Figs | includegraphics=$r4Imgs $(if($r4Pass){'✓'}else{'✗'})" }
if ($r4Pass) { OK "R4: Hình ảnh $r4Figs labfig ✓" } else { WARN "R4: Chỉ có $r4Figs labfig (nên >= 60)" }

# R5: Quy ước đặt tên file Lab1/Ex01.asc sai (Labl/)
$r5Bad = ($TexSummary | Measure-Object -Property AscBadPath -Sum).Sum
$r5Pass = ($r5Bad -eq 0)
$RequirementsCheck += [PSCustomObject]@{ Req="R5"; Mô_tả="Đặt tên file đúng chuẩn LabN/ExNN.asc (không dùng 'Labl/')"; Kết_quả=if($r5Pass){"✓ ĐẠT"}else{"✗ $r5Bad chỗ sai 'Labl/'"} }
if ($r5Pass) { OK "R5: Quy ước đường dẫn .asc ✓" } else { FAIL "R5: $r5Bad chỗ dùng 'Labl/' thay cho 'Lab1/'" }

# R6: File mô phỏng .asc / .cir tồn tại
$r6Found   = ($SimSummary | Measure-Object -Property Found -Sum).Sum
$r6Required= ($SimSummary | Measure-Object -Property Required -Sum).Sum
$r6Pass    = ($r6Found -ge $r6Required)
$RequirementsCheck += [PSCustomObject]@{ Req="R6"; Mô_tả="File mô phỏng .asc/.cir đủ (LabN/Ex01-12)"; Kết_quả="$r6Found/$r6Required $(if($r6Pass){'✓ ĐẠT'}else{'✗ CHƯA ĐẠT'})" }
if ($r6Pass) { OK "R6: File mô phỏng $r6Found/$r6Required ✓" } else { WARN "R6: Chỉ có $r6Found/$r6Required file mô phỏng" }

# =============================================================================
# PHẦN 4: SO SÁNH FILE LAB GỐC vs FILE LAB MỚI (theo từng lab)
# =============================================================================
HEAD "PHẦN 4: So sánh Lab gốc (PSpice) vs Lab mới (LTspice)"

# Thông tin từ bang_trang_thai - đã biết từ trước
$OriginalMapping = @{
    1 = @{ Orig="Ch.1 First Project on PSpice (10 Ex)";  New="DC Circuit Analysis – First Project on LTspice" }
    2 = @{ Orig="Ch.2 Diode Circuits (3.1–3.10)";        New="Diode Circuits Analysis on LTspice" }
    3 = @{ Orig="Ch.3 BJT (13 mục → 10 bài)";           New="BJT Circuits on LTspice" }
    4 = @{ Orig="Ch.5 Op-amp (7 bài + 3 bổ sung)";       New="Op-amp Circuits on LTspice" }
    5 = @{ Orig="Ch.6 FET (bổ sung cho đủ 10)";          New="FET/MOSFET Circuits on LTspice" }
    6 = @{ Orig="Ch.7 24-Hour Project Midterm (8+2)";    New="Mixed Circuits – Midterm Review" }
}

$CompareResults = @()
for ($lab = 1; $lab -le 6; $lab++) {
    $texFile = Join-Path $Root "tex\lab$lab.tex"
    if (-not (Test-Path $texFile)) { $texFile = Join-Path $Root "lab$lab.tex" }
    if (-not (Test-Path $texFile)) { continue }

    $content = Get-Content $texFile -Raw -Encoding utf8

    # Đếm status values
    $statusUnchanged = ([regex]::Matches($content, '\\status\{[^}]*(Unchanged|Giữ nguyên|direct transfer)[^}]*\}')).Count
    $statusModified  = ([regex]::Matches($content, '\\status\{[^}]*(Modified|Điều chỉnh|adjusted)[^}]*\}')).Count
    $statusReplaced  = ([regex]::Matches($content, '\\status\{[^}]*(Replaced|Thay thế|equivalent)[^}]*\}')).Count
    $statusAdv       = ([regex]::Matches($content, '\\status\{[^}]*(Nâng cao|Advanced|Bổ sung|added)[^}]*\}')).Count

    # Lấy title của chap
    $chapTitle = ""
    if ($content -match '\\chap\{([^}]+)\}') { $chapTitle = $matches[1] }

    $row = [PSCustomObject]@{
        Lab       = "Lab $lab"
        Gốc       = $OriginalMapping[$lab].Orig
        Mới       = $chapTitle.Trim()
        Unchanged = $statusUnchanged
        Modified  = $statusModified
        Replaced  = $statusReplaced
        Advanced  = $statusAdv
        TotalTag  = $statusUnchanged + $statusModified + $statusReplaced + $statusAdv
    }
    $CompareResults += $row

    Write-Host ("  Lab {0}: Unchanged={1}  Modified={2}  Replaced={3}  Adv/Added={4}  → Tổng tag={5}" -f `
        $lab, $statusUnchanged, $statusModified, $statusReplaced, $statusAdv, $row.TotalTag)
}

# =============================================================================
# PHẦN 5: TÓM TẮT CẢNH BÁO & LỖI
# =============================================================================
HEAD "PHẦN 5: Tổng hợp vấn đề cần sửa"

if ($Errors.Count -gt 0) {
    Write-Host "`n[LỖI NGHIÊM TRỌNG - cần sửa trước khi nộp]" -ForegroundColor Red
    $Errors | ForEach-Object { Write-Host "  ✗ $_" -ForegroundColor Red }
} else {
    OK "Không có lỗi nghiêm trọng"
}

if ($Warnings.Count -gt 0) {
    Write-Host "`n[CẢNH BÁO - nên kiểm tra lại]" -ForegroundColor Yellow
    $Warnings | ForEach-Object { Write-Host "  ! $_" -ForegroundColor Yellow }
} else {
    OK "Không có cảnh báo"
}

# =============================================================================
# XUẤT BÁO CÁO MARKDOWN
# =============================================================================
HEAD "XUẤT BÁO CÁO: full_audit_report.md"

$md = @"
# Full Audit Report — LTspice Manual Lab1-6
**Thời gian kiểm tra:** $Timestamp  
**Thư mục:** $Root

---

## Phần 1: Cấu trúc .tex theo từng Lab

| Lab | Chapter | Ex(Req) | Ex(Có) | OK | Adv(Req) | Adv(Có) | OK | Status(Req) | Status(Có) | OK | Theory | Sim | Comp | Figures | Labl/Err |
|-----|---------|---------|--------|----|----------|---------|----|-----------|-----------|----|--------|-----|------|---------|----------|
"@

foreach ($r in $TexSummary) {
    $md += "| $($r.Lab) | $($r.Chapter) | $($r.ExReq) | $($r.ExFound) | $($r.ExOK) | $($r.AdvReq) | $($r.AdvFound) | $($r.AdvOK) | $($r.StatusReq) | $($r.StatusFound) | $($r.StatusOK) | $($r.Theory) | $($r.Sim) | $($r.CompTable) | $($r.Figures) | $($r.AscBadPath) |`n"
}

$md += @"

---

## Phần 2: File mô phỏng .asc / .cir

| Lab | Thư mục | Yêu cầu | Tìm thấy | File thiếu |
|-----|---------|---------|----------|-----------|
"@

foreach ($r in $SimSummary) {
    $md += "| $($r.Lab) | $($r.Dir) | $($r.Required) | $($r.Found) | $($r.Missing) |`n"
}

$md += @"

---

## Phần 3: Đối chiếu yêu cầu giáo viên (CO2037 Dự án 3)

| Mã | Yêu cầu | Kết quả |
|----|---------|---------|
"@

foreach ($r in $RequirementsCheck) {
    $md += "| $($r.Req) | $($r.Mô_tả) | $($r.Kết_quả) |`n"
}

$md += @"

---

## Phần 4: So sánh Lab gốc (PSpice) vs Lab mới (LTspice)

| Lab | Tài liệu gốc | Tên chương mới | Unchanged | Modified | Replaced | Adv/Added | Tổng tag |
|-----|-------------|---------------|-----------|----------|----------|-----------|----------|
"@

foreach ($r in $CompareResults) {
    $md += "| $($r.Lab) | $($r.Gốc) | $($r.Mới) | $($r.Unchanged) | $($r.Modified) | $($r.Replaced) | $($r.Advanced) | $($r.TotalTag) |`n"
}

$md += @"

---

## Phần 5: Tổng hợp lỗi & cảnh báo

### Lỗi nghiêm trọng (phải sửa)
"@

if ($Errors.Count -eq 0) {
    $md += "✅ Không có lỗi nghiêm trọng`n"
} else {
    foreach ($e in $Errors) { $md += "- ❌ $e`n" }
}

$md += "`n### Cảnh báo (nên kiểm tra)`n"
if ($Warnings.Count -eq 0) {
    $md += "✅ Không có cảnh báo`n"
} else {
    foreach ($w in $Warnings) { $md += "- ⚠️ $w`n" }
}

$md += @"

---

## Checklist nghiệm thu (trước khi nộp)

- [ ] **R1** – Đủ 72 bài (6 lab × 10 chính + 2 nâng cao)
- [ ] **R2** – Mọi bài có ``\status{}`` ghi rõ Unchanged / Modified / Replaced
- [ ] **R3** – Cấu trúc bắt buộc: Statement → Theory calculation → LTspice simulation → Comparison table
- [ ] **R4** – Mỗi bài có hình circuit ``\labfig{}``
- [ ] **R5** – Đường dẫn file chuẩn ``Lab1/Ex01.asc`` (không dùng ``Labl/``, ``Lab3 3/``)
- [ ] **R6** – File ``.asc`` / ``.cir`` đầy đủ trong ``sim\LabN\``
- [ ] **R7** – Ảnh thực tế từ LTspice (không còn placeholder ``[Insert screenshot]``)
- [ ] **R8** – Bảng Comparison có cột ``Error (%)`` = |Lý thuyết − Mô phỏng| / Lý thuyết × 100
- [ ] **R9** – Ký hiệu toán học đúng (β, Ω, v₀, kΩ — không lẫn OCR lỗi)
- [ ] **R10** – Mục lục cập nhật số trang sau khi thêm ảnh
"@

$md | Set-Content $ReportOut -Encoding utf8
Write-Host "`n✅ Báo cáo đã lưu: $ReportOut" -ForegroundColor Green

# Tổng kết console
HEAD "TỔNG KẾT"
$totalEx    = ($TexSummary | Measure-Object -Property ExFound  -Sum).Sum
$totalAdv   = ($TexSummary | Measure-Object -Property AdvFound -Sum).Sum
$totalSt    = ($TexSummary | Measure-Object -Property StatusFound -Sum).Sum
$totalSim   = ($SimSummary | Measure-Object -Property Found -Sum).Sum
$totalSimReq= ($SimSummary | Measure-Object -Property Required -Sum).Sum

Write-Host ""
Write-Host ("  Bài tập chính:   {0}/60" -f $totalEx)  -ForegroundColor White
Write-Host ("  Bài nâng cao:    {0}/12" -f $totalAdv) -ForegroundColor White
Write-Host ("  Status tags:     {0}/72" -f $totalSt)  -ForegroundColor White
Write-Host ("  File mô phỏng:   {0}/{1}" -f $totalSim, $totalSimReq) -ForegroundColor White
Write-Host ("  Lỗi nghiêm trọng: {0}" -f $Errors.Count)   -ForegroundColor $(if($Errors.Count -eq 0){"Green"}else{"Red"})
Write-Host ("  Cảnh báo:        {0}" -f $Warnings.Count) -ForegroundColor $(if($Warnings.Count -eq 0){"Green"}else{"Yellow"})
Write-Host ""
Write-Host "Báo cáo đầy đủ: $ReportOut" -ForegroundColor Cyan

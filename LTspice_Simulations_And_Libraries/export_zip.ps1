# Script tự động nén thư mục mô phỏng & thư viện thành file .zip nộp bài (STT 3)
$currentDir = $PSScriptRoot
$zipOutput = Join-Path $currentDir "LTspice_Simulations_And_Libraries.zip"

if (Test-Path $zipOutput) {
    Remove-Item $zipOutput -Force
    Write-Host "Da xoa file zip cu: $zipOutput"
}

$simPath = Join-Path $currentDir "sim"
$libPath = Join-Path $currentDir "extra_libraries"
$readmePath = Join-Path $currentDir "README.md"

# Nén sim, extra_libraries và README vào file zip
Compress-Archive -Path $simPath, $libPath, $readmePath -DestinationPath $zipOutput -Force
Write-Host "✅ Da tao thanh cong file zip nop bai: $zipOutput" -ForegroundColor Green

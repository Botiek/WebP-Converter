# PowerShell скрипт для установки контекстного меню "Конвертировать WebP в PNG"
# Запускать от имени администратора

param(
    [switch]$Uninstall
)

# Проверяем права администратора
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Путь к batch файлу
$BatchFile = Join-Path $PSScriptRoot "convert_webp_to_png.bat"

# Проверяем существование batch файла
if (-not (Test-Path $BatchFile)) {
    Write-Host "Error: convert_webp_to_png.bat not found in the same directory." -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

if ($Uninstall) {
    Write-Host "Uninstalling WebP to PNG converter from context menu..." -ForegroundColor Yellow
    
    try {
        # Удаляем контекстное меню для .webp файлов
        Remove-Item "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNG" -Recurse -Force -ErrorAction SilentlyContinue
        
        # Удаляем контекстное меню для папок
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNG" -Recurse -Force -ErrorAction SilentlyContinue
        
        Write-Host "Context menu entries removed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error during uninstallation: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "Installing WebP to PNG converter to context menu..." -ForegroundColor Yellow
    
    try {
        # Создаем контекстное меню для .webp файлов
        $WebPKey = "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNG"
        New-Item -Path $WebPKey -Force | Out-Null
        New-ItemProperty -Path $WebPKey -Name "MUIVerb" -Value "Convert to PNG" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $WebPKey -Name "Icon" -Value "shell32.dll,3" -PropertyType String -Force | Out-Null
        
        $WebPCommandKey = "$WebPKey\command"
        New-Item -Path $WebPCommandKey -Force | Out-Null
        New-ItemProperty -Path $WebPCommandKey -Name "(Default)" -Value "`"$BatchFile`" `"%1`"" -PropertyType String -Force | Out-Null
        
        # Создаем контекстное меню для папок
        $DirKey = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNG"
        New-Item -Path $DirKey -Force | Out-Null
        New-ItemProperty -Path $DirKey -Name "MUIVerb" -Value "Convert WebP to PNG" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $DirKey -Name "Icon" -Value "shell32.dll,3" -PropertyType String -Force | Out-Null
        
        $DirCommandKey = "$DirKey\command"
        New-Item -Path $DirCommandKey -Force | Out-Null
        New-ItemProperty -Path $DirCommandKey -Name "(Default)" -Value "`"$BatchFile`" `"%1`"" -PropertyType String -Force | Out-Null
        
        Write-Host "Context menu installed successfully!" -ForegroundColor Green
        Write-Host "Now you can:" -ForegroundColor Cyan
        Write-Host "  - Right-click on any .webp file and select 'Convert to PNG'" -ForegroundColor White
        Write-Host "  - Right-click on any folder and select 'Convert WebP to PNG' to convert all WebP files in that folder" -ForegroundColor White
    }
    catch {
        Write-Host "Error during installation: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


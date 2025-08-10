# PowerShell script for installing/uninstalling "Convert WebP to PNG" context menu
# Run as Administrator

param(
    [switch]$Uninstall
)

# Check for Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Path to batch file
$BatchFile = Join-Path $PSScriptRoot "webp2png.bat"

# Check if batch file exists
if (-not (Test-Path $BatchFile)) {
    Write-Host "Error: webp2png.bat not found in the same directory." -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

if ($Uninstall) {
    Write-Host "Uninstalling WebP to PNG converter from context menu..." -ForegroundColor Yellow
    
    try {
        # Remove context menu for .webp files
        Remove-Item "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNG" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNGAndDelete" -Recurse -Force -ErrorAction SilentlyContinue
        
        # Remove context menu for folders
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNG" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNGAndDelete" -Recurse -Force -ErrorAction SilentlyContinue
        
        Write-Host "Context menu entries removed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error during uninstallation: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "Installing WebP to PNG converter to context menu..." -ForegroundColor Yellow
    
    try {
        # Create context menu for .webp files - Basic conversion
        $WebPKey = "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNG"
        New-Item -Path $WebPKey -Force | Out-Null
        New-ItemProperty -Path $WebPKey -Name "MUIVerb" -Value "Convert to PNG" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $WebPKey -Name "Icon" -Value "shell32.dll,3" -PropertyType String -Force | Out-Null
        
        $WebPCommandKey = "$WebPKey\command"
        New-Item -Path $WebPCommandKey -Force | Out-Null
        New-ItemProperty -Path $WebPCommandKey -Name "(Default)" -Value "`"$BatchFile`" `"%1`"" -PropertyType String -Force | Out-Null
        
        # Create context menu for .webp files - Convert and delete
        $WebPDeleteKey = "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNGAndDelete"
        New-Item -Path $WebPDeleteKey -Force | Out-Null
        New-ItemProperty -Path $WebPDeleteKey -Name "MUIVerb" -Value "Convert to PNG and Delete Original" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $WebPDeleteKey -Name "Icon" -Value "shell32.dll,32" -PropertyType String -Force | Out-Null
        
        $WebPDeleteCommandKey = "$WebPDeleteKey\command"
        New-Item -Path $WebPDeleteCommandKey -Force | Out-Null
        New-ItemProperty -Path $WebPDeleteCommandKey -Name "(Default)" -Value "`"$BatchFile`" --delete `"%1`"" -PropertyType String -Force | Out-Null
        
        # Create context menu for folders - Basic conversion
        $FolderKey = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNG"
        New-Item -Path $FolderKey -Force | Out-Null
        New-ItemProperty -Path $FolderKey -Name "MUIVerb" -Value "Convert WebP to PNG" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $FolderKey -Name "Icon" -Value "shell32.dll,3" -PropertyType String -Force | Out-Null
        
        $FolderCommandKey = "$FolderKey\command"
        New-Item -Path $FolderCommandKey -Force | Out-Null
        New-ItemProperty -Path $FolderCommandKey -Name "(Default)" -Value "`"$BatchFile`" `"%1`"" -PropertyType String -Force | Out-Null
        
        # Create context menu for folders - Convert and delete
        $FolderDeleteKey = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNGAndDelete"
        New-Item -Path $FolderDeleteKey -Force | Out-Null
        New-ItemProperty -Path $FolderDeleteKey -Name "MUIVerb" -Value "Convert WebP to PNG and Delete Originals" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $FolderDeleteKey -Name "Icon" -Value "shell32.dll,32" -PropertyType String -Force | Out-Null
        
        $FolderDeleteCommandKey = "$FolderDeleteKey\command"
        New-Item -Path $FolderDeleteCommandKey -Force | Out-Null
        New-ItemProperty -Path $FolderDeleteCommandKey -Name "(Default)" -Value "`"$BatchFile`" --delete `"%1`"" -PropertyType String -Force | Out-Null
        
        Write-Host "Context menu installed successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "You now have 2 context menu options for WebP files:" -ForegroundColor Cyan
        Write-Host "1. Convert to PNG" -ForegroundColor White
        Write-Host "2. Convert to PNG and Delete Original" -ForegroundColor White
        Write-Host ""
        Write-Host "And 2 options for folders:" -ForegroundColor Cyan
        Write-Host "1. Convert WebP to PNG" -ForegroundColor White
        Write-Host "2. Convert WebP to PNG and Delete Originals" -ForegroundColor White
        Write-Host ""
        Write-Host "Note: All windows close automatically after 3 seconds!" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Error during installation: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


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
$BatchFile = Join-Path $PSScriptRoot "convert_webp_to_png.bat"

# Check if batch file exists
if (-not (Test-Path $BatchFile)) {
    Write-Host "Error: convert_webp_to_png.bat not found in the same directory." -ForegroundColor Red
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
        Remove-Item "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNGAutoClose" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNGAndDeleteAutoClose" -Recurse -Force -ErrorAction SilentlyContinue
        
        # Remove context menu for folders
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNG" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNGAndDelete" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNGAutoClose" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNGAndDeleteAutoClose" -Recurse -Force -ErrorAction SilentlyContinue
        
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
        
        # Create context menu for .webp files - Convert with auto-close
        $WebPAutoCloseKey = "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNGAutoClose"
        New-Item -Path $WebPAutoCloseKey -Force | Out-Null
        New-ItemProperty -Path $WebPAutoCloseKey -Name "MUIVerb" -Value "Convert to PNG (Auto-Close)" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $WebPAutoCloseKey -Name "Icon" -Value "shell32.dll,4" -PropertyType String -Force | Out-Null
        
        $WebPAutoCloseCommandKey = "$WebPAutoCloseKey\command"
        New-Item -Path $WebPAutoCloseCommandKey -Force | Out-Null
        New-ItemProperty -Path $WebPAutoCloseCommandKey -Name "(Default)" -Value "`"$BatchFile`" --auto-close `"%1`"" -PropertyType String -Force | Out-Null
        
        # Create context menu for .webp files - Convert, delete and auto-close
        $WebPDeleteAutoCloseKey = "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\shell\ConvertToPNGAndDeleteAutoClose"
        New-Item -Path $WebPDeleteAutoCloseKey -Force | Out-Null
        New-ItemProperty -Path $WebPDeleteAutoCloseKey -Name "MUIVerb" -Value "Convert to PNG, Delete & Auto-Close" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $WebPDeleteAutoCloseKey -Name "Icon" -Value "shell32.dll,32" -PropertyType String -Force | Out-Null
        
        $WebPDeleteAutoCloseCommandKey = "$WebPDeleteAutoCloseKey\command"
        New-Item -Path $WebPDeleteAutoCloseCommandKey -Force | Out-Null
        New-ItemProperty -Path $WebPDeleteAutoCloseCommandKey -Name "(Default)" -Value "`"$BatchFile`" --auto-close --delete `"%1`"" -PropertyType String -Force | Out-Null
        
        # Create context menu for folders - Basic conversion
        $DirKey = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNG"
        New-Item -Path $DirKey -Force | Out-Null
        New-ItemProperty -Path $DirKey -Name "MUIVerb" -Value "Convert WebP to PNG" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $DirKey -Name "Icon" -Value "shell32.dll,3" -PropertyType String -Force | Out-Null
        
        $DirCommandKey = "$DirKey\command"
        New-Item -Path $DirCommandKey -Force | Out-Null
        New-ItemProperty -Path $DirCommandKey -Name "(Default)" -Value "`"$BatchFile`" `"%1`"" -PropertyType String -Force | Out-Null
        
        # Create context menu for folders - Convert and delete
        $DirDeleteKey = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNGAndDelete"
        New-Item -Path $DirDeleteKey -Force | Out-Null
        New-ItemProperty -Path $DirDeleteKey -Name "MUIVerb" -Value "Convert WebP to PNG and Delete Originals" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $DirDeleteKey -Name "Icon" -Value "shell32.dll,32" -PropertyType String -Force | Out-Null
        
        $DirDeleteCommandKey = "$DirDeleteKey\command"
        New-Item -Path $DirDeleteCommandKey -Force | Out-Null
        New-ItemProperty -Path $DirDeleteCommandKey -Name "(Default)" -Value "`"$BatchFile`" --delete `"%1`"" -PropertyType String -Force | Out-Null
        
        # Create context menu for folders - Convert with auto-close
        $DirAutoCloseKey = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNGAutoClose"
        New-Item -Path $DirAutoCloseKey -Force | Out-Null
        New-ItemProperty -Path $DirAutoCloseKey -Name "MUIVerb" -Value "Convert WebP to PNG (Auto-Close)" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $DirAutoCloseKey -Name "Icon" -Value "shell32.dll,4" -PropertyType String -Force | Out-Null
        
        $DirAutoCloseCommandKey = "$DirAutoCloseKey\command"
        New-Item -Path $DirAutoCloseCommandKey -Force | Out-Null
        New-ItemProperty -Path $DirAutoCloseCommandKey -Name "(Default)" -Value "`"$BatchFile`" --auto-close `"%1`"" -PropertyType String -Force | Out-Null
        
        # Create context menu for folders - Convert, delete and auto-close
        $DirDeleteAutoCloseKey = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ConvertWebPToPNGAndDeleteAutoClose"
        New-Item -Path $DirDeleteAutoCloseKey -Force | Out-Null
        New-ItemProperty -Path $DirDeleteAutoCloseKey -Name "MUIVerb" -Value "Convert WebP to PNG, Delete & Auto-Close" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $DirDeleteAutoCloseKey -Name "Icon" -Value "shell32.dll,32" -PropertyType String -Force | Out-Null
        
        $DirDeleteAutoCloseCommandKey = "$DirDeleteAutoCloseKey\command"
        New-Item -Path $DirDeleteAutoCloseCommandKey -Force | Out-Null
        New-ItemProperty -Path $DirDeleteAutoCloseCommandKey -Name "(Default)" -Value "`"$BatchFile`" --auto-close --delete `"%1`"" -PropertyType String -Force | Out-Null
        
        Write-Host "Context menu installed successfully!" -ForegroundColor Green
        Write-Host "Now you can:" -ForegroundColor Cyan
        Write-Host "  - Right-click on any .webp file and select:" -ForegroundColor White
        Write-Host "    * 'Convert to PNG' - Basic conversion" -ForegroundColor White
        Write-Host "    * 'Convert to PNG and Delete Original' - Convert and delete source" -ForegroundColor White
        Write-Host "    * 'Convert to PNG (Auto-Close)' - Convert and auto-close window" -ForegroundColor White
        Write-Host "    * 'Convert to PNG, Delete & Auto-Close' - All options combined" -ForegroundColor White
        Write-Host "  - Right-click on any folder and select similar options for batch conversion" -ForegroundColor White
    }
    catch {
        Write-Host "Error during installation: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


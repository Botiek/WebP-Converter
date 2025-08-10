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
        


        

        
        Write-Host "Context menu installed successfully!" -ForegroundColor Green
        Write-Host "Now you can:" -ForegroundColor Cyan
        Write-Host "  - Right-click on any .webp file and select:" -ForegroundColor White
        Write-Host "    * 'Convert to PNG' - Basic conversion" -ForegroundColor White
        Write-Host "    * 'Convert to PNG and Delete Original' - Convert and delete source" -ForegroundColor White
        Write-Host "  - Right-click on any folder and select similar options for batch conversion" -ForegroundColor White
    }
    catch {
        Write-Host "Error during installation: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


@echo off
REM Простой конвертер WebP в PNG
REM Использование: convert.bat image.webp

if "%1"=="" (
    echo Использование: convert.bat image.webp
    echo.
    echo Примеры:
    echo   convert.bat image.webp
    echo   convert.bat image.webp --delete
    echo   convert.bat folder/
    pause
    exit /b 1
)

python webp2png.py %*
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [OK] Конвертация завершена успешно!
) else (
    echo.
    echo [ERROR] Ошибка при конвертации!
)

pause

@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "selected_path=%~1"
set "auto_close=false"
set "delete_original=false"

REM Проверяем аргументы командной строки
if "%1"=="--auto-close" (
    set "auto_close=true"
    set "selected_path=%~2"
) else if "%1"=="--delete" (
    set "delete_original=true"
    set "selected_path=%~2"
) else if "%1"=="--auto-close" if "%2"=="--delete" (
    set "auto_close=true"
    set "delete_original=true"
    set "selected_path=%~3"
) else if "%1"=="--delete" if "%2"=="--auto-close" (
    set "auto_close=true"
    set "delete_original=true"
    set "selected_path=%~3"
)

if "%selected_path%"=="" (
    echo ❌ Ошибка: Не выбран файл или папка
    echo.
    echo Использование:
    echo   %~nx0 [опции] путь_к_файлу_или_папке
    echo.
    echo Опции:
    echo   --auto-close    Автоматически закрыть окно после завершения
    echo   --delete        Удалить исходные WebP файлы после конвертации
    echo.
    echo Примеры:
    echo   %~nx0 file.webp
    echo   %~nx0 --auto-close folder/
    echo   %~nx0 --delete file.webp
    echo   %~nx0 --auto-close --delete folder/
    echo.
    if "%auto_close%"=="true" (
        timeout /t 5 >nul
    ) else (
        pause
    )
    exit /b 1
)

set "script_path=%~dp0webp_to_png_converter.py"

if not exist "%script_path%" (
    echo ❌ Ошибка: Python скрипт не найден: %script_path%
    echo Убедитесь, что файл webp_to_png_converter.py находится в той же папке
    if "%auto_close%"=="true" (
        timeout /t 5 >nul
    ) else (
        pause
    )
    exit /b 1
)

python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Ошибка: Python не установлен или не добавлен в PATH
    echo Установите Python с сайта https://python.org
    if "%auto_close%"=="true" (
        timeout /t 5 >nul
    ) else (
        pause
    )
    exit /b 1
)

python -c "import PIL" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Устанавливаем библиотеку Pillow...
    pip install Pillow
    if errorlevel 1 (
        echo ❌ Ошибка: Не удалось установить Pillow
        if "%auto_close%"=="true" (
            timeout /t 5 >nul
        ) else (
            pause
        )
        exit /b 1
    )
)

echo 🚀 Запуск конвертера WebP в PNG...
echo 📁 Выбранный путь: %selected_path%
if "%delete_original%"=="true" (
    echo 🗑️  Режим: Удаление исходных файлов после конвертации
)
if "%auto_close%"=="true" (
    echo ⏰ Режим: Автоматическое закрытие после завершения
)
echo.

REM Формируем команду для Python скрипта
set "python_cmd=python "%script_path%""
if "%delete_original%"=="true" (
    set "python_cmd=%python_cmd% --delete"
)
set "python_cmd=%python_cmd% "%selected_path%""

REM Выполняем команду
%python_cmd%

echo.
if "%auto_close%"=="true" (
    echo ✅ Готово! Окно закроется автоматически через 3 секунды...
    timeout /t 3 >nul
) else (
    echo ✅ Готово! Нажмите любую клавишу для закрытия...
    pause >nul
)


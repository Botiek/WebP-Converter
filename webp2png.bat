@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "selected_path=%~1"
set "delete_original=false"

REM Проверяем аргументы командной строки
set "arg1=%1"
set "arg2=%2"

REM Обрабатываем опции
if "%arg1%"=="--delete" (
    set "delete_original=true"
    set "selected_path=%arg2%"
) else (
    set "selected_path=%arg1%"
)

if "%selected_path%"=="" (
    echo [ERROR] Ошибка: Не выбран файл или папка
    echo.
    echo Использование:
echo   %~nx0 [опции] путь_к_файлу_или_папке
echo.
echo Опции:
echo   --delete        Удалить исходные WebP файлы после конвертации
echo.
echo Примеры:
echo   %~nx0 file.webp
echo   %~nx0 folder/
echo   %~nx0 --delete file.webp
echo   %~nx0 --delete folder/
echo.
timeout /t 5 >nul
exit /b 1
)

set "script_path=%~dp0webp2png.py"

if not exist "%script_path%" (
    echo [ERROR] Ошибка: Python скрипт не найден: %script_path%
    echo Убедитесь, что файл webp2png.py находится в той же папке
    timeout /t 5 >nul
    exit /b 1
)

python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Ошибка: Python не установлен или не добавлен в PATH
    echo Установите Python с сайта https://python.org
    timeout /t 5 >nul
    exit /b 1
)

python -c "import PIL" >nul 2>&1
if errorlevel 1 (
    echo [WARN] Устанавливаем библиотеку Pillow...
    pip install Pillow
    if errorlevel 1 (
        echo [ERROR] Ошибка: Не удалось установить Pillow
        timeout /t 5 >nul
        exit /b 1
    )
)

echo [INFO] Запуск конвертера WebP в PNG...
echo [INFO] Выбранный путь: %selected_path%
if "%delete_original%"=="true" (
    echo [INFO] Режим: Удаление исходных файлов после конвертации
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
echo [OK] Готово! Окно закроется автоматически через 3 секунды...
timeout /t 3 >nul

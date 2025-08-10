@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Получаем путь к выбранному файлу/папке
set "selected_path=%~1"

:: Проверяем, что путь передан
if "%selected_path%"=="" (
    echo ❌ Ошибка: Не выбран файл или папка
    pause
    exit /b 1
)

:: Получаем путь к Python скрипту (должен быть в той же папке)
set "script_path=%~dp0webp_to_png_converter.py"

:: Проверяем существование Python скрипта
if not exist "%script_path%" (
    echo ❌ Ошибка: Python скрипт не найден: %script_path%
    echo Убедитесь, что файл webp_to_png_converter.py находится в той же папке
    pause
    exit /b 1
)

:: Проверяем, что Python установлен
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Ошибка: Python не установлен или не добавлен в PATH
    echo Установите Python с сайта https://python.org
    pause
    exit /b 1
)

:: Проверяем, что установлен Pillow
python -c "import PIL" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Устанавливаем библиотеку Pillow...
    pip install Pillow
    if errorlevel 1 (
        echo ❌ Ошибка: Не удалось установить Pillow
        pause
        exit /b 1
    )
)

echo 🚀 Запуск конвертера WebP в PNG...
echo 📁 Выбранный путь: %selected_path%
echo.

:: Запускаем Python скрипт
python "%script_path%" "%selected_path%"

echo.
echo ✅ Готово! Нажмите любую клавишу для закрытия...
pause >nul


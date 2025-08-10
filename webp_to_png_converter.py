#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
WebP to PNG Converter
Конвертер WebP файлов в PNG формат с поддержкой прозрачности
"""

import os
import sys
import argparse
from pathlib import Path
import subprocess
import shutil

def install_pillow():
    """Устанавливает библиотеку Pillow если она не установлена"""
    try:
        import PIL
        return True
    except ImportError:
        print("⚠️ Устанавливаем библиотеку Pillow...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow"])
            return True
        except subprocess.CalledProcessError:
            print("❌ Ошибка: Не удалось установить Pillow")
            return False

def convert_webp_to_png(input_path, output_path=None, delete_original=False):
    """
    Конвертирует WebP файл в PNG
    
    Args:
        input_path (str): Путь к входному WebP файлу
        output_path (str, optional): Путь для выходного PNG файла
        delete_original (bool): Удалить исходный файл после конвертации
    
    Returns:
        bool: True если конвертация успешна, False в противном случае
    """
    try:
        from PIL import Image
        
        # Открываем WebP изображение
        with Image.open(input_path) as img:
            # Конвертируем в RGB если изображение в режиме RGBA или LA
            if img.mode in ('RGBA', 'LA'):
                # Создаем белый фон
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'RGBA':
                    background.paste(img, mask=img.split()[-1])  # Используем альфа-канал как маску
                else:  # LA режим
                    background.paste(img, mask=img.split()[-1])
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Определяем путь для выходного файла
            if output_path is None:
                output_path = str(Path(input_path).with_suffix('.png'))
            
            # Сохраняем как PNG
            img.save(output_path, 'PNG', optimize=True)
            
            print(f"✅ Конвертирован: {input_path} → {output_path}")
            
            # Удаляем исходный файл если требуется
            if delete_original:
                try:
                    os.remove(input_path)
                    print(f"🗑️ Удален исходный файл: {input_path}")
                except OSError as e:
                    print(f"⚠️ Предупреждение: Не удалось удалить исходный файл: {e}")
            
            return True
            
    except ImportError:
        print("❌ Ошибка: Библиотека Pillow не установлена")
        return False
    except Exception as e:
        print(f"❌ Ошибка при конвертации {input_path}: {e}")
        return False

def process_directory(directory_path, delete_original=False):
    """
    Обрабатывает все WebP файлы в указанной директории
    
    Args:
        directory_path (str): Путь к директории
        delete_original (bool): Удалить исходные файлы после конвертации
    
    Returns:
        tuple: (количество успешных конвертаций, общее количество файлов)
    """
    directory = Path(directory_path)
    if not directory.is_dir():
        print(f"❌ Ошибка: {directory_path} не является директорией")
        return 0, 0
    
    webp_files = list(directory.glob("**/*.webp"))  # Рекурсивный поиск
    if not webp_files:
        print(f"ℹ️ В директории {directory_path} не найдено WebP файлов")
        return 0, 0
    
    print(f"📁 Найдено {len(webp_files)} WebP файлов в {directory_path}")
    
    success_count = 0
    for webp_file in webp_files:
        if convert_webp_to_png(str(webp_file), delete_original=delete_original):
            success_count += 1
    
    return success_count, len(webp_files)

def main():
    """Основная функция"""
    parser = argparse.ArgumentParser(
        description="Конвертер WebP файлов в PNG формат",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Примеры использования:
  %(prog)s image.webp                    # Конвертация одного файла
  %(prog)s image.webp --delete           # Конвертация с удалением исходного
  %(prog)s photos/ --delete              # Конвертация папки с удалением
  %(prog)s image.webp -o result.png      # Указание выходного файла
        """
    )
    
    parser.add_argument("input", help="Путь к WebP файлу или папке")
    parser.add_argument("--delete", action="store_true", 
                       help="Удалить исходные WebP файлы после конвертации")
    parser.add_argument("-o", "--output", 
                       help="Путь для выходного PNG файла (только для одного файла)")
    
    args = parser.parse_args()
    
    # Проверяем существование входного пути
    if not os.path.exists(args.input):
        print(f"❌ Ошибка: Путь {args.input} не существует")
        return 1
    
    # Устанавливаем Pillow если нужно
    if not install_pillow():
        return 1
    
    input_path = Path(args.input)
    
    if input_path.is_file():
        # Обработка одного файла
        if input_path.suffix.lower() != '.webp':
            print(f"❌ Ошибка: {input_path} не является WebP файлом")
            return 1
        
        if convert_webp_to_png(str(input_path), args.output, args.delete):
            print("🎉 Конвертация завершена успешно!")
            return 0
        else:
            print("❌ Конвертация завершилась с ошибками")
            return 1
    
    elif input_path.is_dir():
        # Обработка директории
        if args.output:
            print("⚠️ Предупреждение: --output игнорируется при обработке директории")
        
        success_count, total_count = process_directory(str(input_path), args.delete)
        
        if success_count == total_count:
            print(f"🎉 Все {total_count} файлов конвертированы успешно!")
            return 0
        else:
            print(f"⚠️ Конвертировано {success_count} из {total_count} файлов")
            return 1 if success_count == 0 else 0
    
    else:
        print(f"❌ Ошибка: {input_path} не является файлом или директорией")
        return 1

if __name__ == "__main__":
    sys.exit(main())


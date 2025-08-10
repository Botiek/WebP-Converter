#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Конвертер WebP в PNG для контекстного меню Windows
"""

import sys
import os
from PIL import Image
import argparse

def convert_webp_to_png(input_path, output_path=None, delete_original=False):
    """
    Конвертирует WebP файл в PNG формат
    
    Args:
        input_path (str): Путь к входному WebP файлу
        output_path (str, optional): Путь для выходного PNG файла
        delete_original (bool): Удалить исходный файл после конвертации
    """
    try:
        with Image.open(input_path) as img:
            if output_path is None:
                base_name = os.path.splitext(input_path)[0]
                output_path = f"{base_name}.png"
            
            if img.mode in ('RGBA', 'LA'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'RGBA':
                    background.paste(img, mask=img.split()[-1])
                else:
                    background.paste(img)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            img.save(output_path, 'PNG', optimize=True)
            print(f"✅ Успешно конвертировано: {input_path} -> {output_path}")
            
            # Удаляем исходный файл если требуется
            if delete_original:
                try:
                    os.remove(input_path)
                    print(f"🗑️  Исходный файл удален: {input_path}")
                except Exception as e:
                    print(f"⚠️  Не удалось удалить исходный файл {input_path}: {str(e)}")
            
            return True
            
    except Exception as e:
        print(f"❌ Ошибка при конвертации {input_path}: {str(e)}")
        return False

def process_directory(directory_path, delete_original=False):
    """
    Обрабатывает все WebP файлы в директории
    
    Args:
        directory_path (str): Путь к директории
        delete_original (bool): Удалить исходные файлы после конвертации
    """
    if not os.path.isdir(directory_path):
        print(f"❌ Ошибка: {directory_path} не является директорией")
        return False
    
    webp_files = []
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            if file.lower().endswith('.webp'):
                webp_files.append(os.path.join(root, file))
    
    if not webp_files:
        print(f"📁 В директории {directory_path} не найдено WebP файлов")
        return True
    
    print(f"🔍 Найдено {len(webp_files)} WebP файлов для конвертации")
    print()
    
    success_count = 0
    for webp_file in webp_files:
        if convert_webp_to_png(webp_file, delete_original=delete_original):
            success_count += 1
        print()
    
    print(f"📊 Результат: {success_count}/{len(webp_files)} файлов успешно конвертировано")
    return success_count == len(webp_files)

def main():
    parser = argparse.ArgumentParser(
        description='Конвертер WebP файлов в PNG формат',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Примеры использования:
  %(prog)s file.webp                    # Конвертировать один файл
  %(prog)s file.webp --delete          # Конвертировать и удалить исходный
  %(prog)s folder/ --delete            # Конвертировать все WebP в папке
  %(prog)s folder/ --output output.png # Указать выходной файл
        """
    )
    
    parser.add_argument('input', help='Путь к WebP файлу или папке')
    parser.add_argument('-o', '--output', help='Путь для выходного PNG файла')
    parser.add_argument('-d', '--delete', action='store_true', 
                       help='Удалить исходные WebP файлы после конвертации')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.input):
        print(f"❌ Ошибка: Путь {args.input} не существует")
        return 1
    
    if os.path.isfile(args.input):
        # Обработка одного файла
        if not args.input.lower().endswith('.webp'):
            print(f"❌ Ошибка: {args.input} не является WebP файлом")
            return 1
        
        success = convert_webp_to_png(args.input, args.output, args.delete)
        return 0 if success else 1
    
    elif os.path.isdir(args.input):
        # Обработка директории
        success = process_directory(args.input, args.delete)
        return 0 if success else 1
    
    else:
        print(f"❌ Ошибка: {args.input} не является файлом или директорией")
        return 1

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)


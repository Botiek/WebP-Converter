#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Конвертер WebP в PNG для контекстного меню Windows
"""

import sys
import os
from PIL import Image
import argparse

def convert_webp_to_png(input_path, output_path=None):
    """
    Конвертирует WebP файл в PNG формат
    
    Args:
        input_path (str): Путь к входному WebP файлу
        output_path (str, optional): Путь для выходного PNG файла
    """
    try:
        # Открываем WebP изображение
        with Image.open(input_path) as img:
            # Если выходной путь не указан, создаем его автоматически
            if output_path is None:
                base_name = os.path.splitext(input_path)[0]
                output_path = f"{base_name}.png"
            
            # Конвертируем в RGB если изображение в RGBA
            if img.mode in ('RGBA', 'LA'):
                # Создаем белый фон для прозрачных изображений
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'RGBA':
                    background.paste(img, mask=img.split()[-1])  # Используем альфа-канал как маску
                else:
                    background.paste(img)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Сохраняем как PNG
            img.save(output_path, 'PNG', optimize=True)
            print(f"✅ Успешно конвертировано: {input_path} -> {output_path}")
            return True
            
    except Exception as e:
        print(f"❌ Ошибка при конвертации {input_path}: {str(e)}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Конвертер WebP в PNG')
    parser.add_argument('input', help='Путь к WebP файлу или папке')
    parser.add_argument('-o', '--output', help='Путь для выходного файла (опционально)')
    parser.add_argument('-r', '--recursive', action='store_true', help='Рекурсивно обработать папки')
    
    args = parser.parse_args()
    
    input_path = args.input
    
    if not os.path.exists(input_path):
        print(f"❌ Файл или папка не найдены: {input_path}")
        sys.exit(1)
    
    if os.path.isfile(input_path):
        # Обрабатываем один файл
        if input_path.lower().endswith('.webp'):
            convert_webp_to_png(input_path, args.output)
        else:
            print(f"❌ Файл не является WebP: {input_path}")
            sys.exit(1)
    
    elif os.path.isdir(input_path):
        # Обрабатываем папку
        converted_count = 0
        total_count = 0
        
        if args.recursive:
            # Рекурсивный обход
            for root, dirs, files in os.walk(input_path):
                for file in files:
                    if file.lower().endswith('.webp'):
                        total_count += 1
                        file_path = os.path.join(root, file)
                        if convert_webp_to_png(file_path):
                            converted_count += 1
        else:
            # Только файлы в текущей папке
            for file in os.listdir(input_path):
                if file.lower().endswith('.webp'):
                    total_count += 1
                    file_path = os.path.join(input_path, file)
                    if convert_webp_to_png(file_path):
                        converted_count += 1
        
        print(f"\n📊 Результат: {converted_count}/{total_count} файлов успешно конвертировано")
        
        if converted_count > 0:
            print("✅ Конвертация завершена успешно!")
        else:
            print("⚠️  WebP файлы не найдены для конвертации")

if __name__ == "__main__":
    main()


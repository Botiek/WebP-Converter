#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Тестовый скрипт для проверки работы конвертера WebP в PNG
"""

import os
import sys
from PIL import Image
import tempfile

def create_test_webp():
    """Создает тестовый WebP файл для проверки"""
    try:
        # Создаем простое тестовое изображение
        img = Image.new('RGB', (100, 100), color='red')
        
        # Создаем временную папку
        temp_dir = tempfile.mkdtemp()
        test_webp = os.path.join(temp_dir, 'test.webp')
        
        # Сохраняем как WebP
        img.save(test_webp, 'WEBP')
        
        print(f"✅ Тестовый WebP файл создан: {test_webp}")
        return test_webp, temp_dir
        
    except Exception as e:
        print(f"❌ Ошибка при создании тестового файла: {e}")
        return None, None

def test_conversion(webp_path):
    """Тестирует конвертацию WebP в PNG"""
    try:
        # Импортируем функцию конвертации
        sys.path.append(os.path.dirname(os.path.abspath(__file__)))
        from webp_to_png_converter import convert_webp_to_png
        
        # Конвертируем
        png_path = webp_path.replace('.webp', '.png')
        success = convert_webp_to_png(webp_path, png_path)
        
        if success and os.path.exists(png_path):
            print(f"✅ Конвертация успешна: {png_path}")
            
            # Проверяем размер файла
            webp_size = os.path.getsize(webp_path)
            png_size = os.path.getsize(png_path)
            print(f"📊 Размер WebP: {webp_size} байт")
            print(f"📊 Размер PNG: {png_size} байт")
            
            return True
        else:
            print("❌ Конвертация не удалась")
            return False
            
    except Exception as e:
        print(f"❌ Ошибка при тестировании: {e}")
        return False

def main():
    print("🧪 Тестирование конвертера WebP в PNG")
    print("=" * 50)
    
    # Проверяем наличие необходимых библиотек
    try:
        from PIL import Image
        print("✅ Pillow установлен")
    except ImportError:
        print("❌ Pillow не установлен. Установите: pip install Pillow")
        return
    
    # Создаем тестовый файл
    webp_path, temp_dir = create_test_webp()
    if not webp_path:
        return
    
    try:
        # Тестируем конвертацию
        success = test_conversion(webp_path)
        
        if success:
            print("\n🎉 Все тесты пройдены успешно!")
            print("Конвертер готов к использованию.")
        else:
            print("\n❌ Тесты не пройдены.")
            
    finally:
        # Очищаем временные файлы
        if temp_dir and os.path.exists(temp_dir):
            import shutil
            shutil.rmtree(temp_dir)
            print(f"🧹 Временные файлы удалены")

if __name__ == "__main__":
    main()


#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Демонстрация всех возможностей WebP to PNG конвертера
"""

import os
import sys
import subprocess
from PIL import Image, ImageDraw, ImageFont

def create_demo_images():
    """Создает демонстрационные WebP изображения"""
    print("[INFO] Создание демонстрационных изображений...")
    
    # Создаем папку для демо
    demo_dir = "demo_images"
    if not os.path.exists(demo_dir):
        os.makedirs(demo_dir)
    
    # Изображение 1: Простой градиент
    img1 = Image.new('RGB', (300, 200), color='#FF6B6B')
    draw1 = ImageDraw.Draw(img1)
    for y in range(200):
        r = int(255 - (y * 100 / 200))
        g = int(107 + (y * 50 / 200))
        b = int(107 + (y * 100 / 200))
        draw1.line([(0, y), (300, y)], fill=(r, g, b))
    
    # Добавляем текст
    try:
        font = ImageFont.truetype("arial.ttf", 24)
    except:
        font = ImageFont.load_default()
    
    draw1.text((50, 80), "Gradient", fill='white', font=font)
    img1.save(f"{demo_dir}/gradient.webp", 'WEBP', quality=90)
    
    # Изображение 2: Геометрические фигуры
    img2 = Image.new('RGB', (300, 200), color='#4ECDC4')
    draw2 = ImageDraw.Draw(img2)
    
    # Круг
    draw2.ellipse([50, 50, 150, 150], fill='#FFE66D', outline='#FF6B6B', width=3)
    # Прямоугольник
    draw2.rectangle([180, 80, 250, 120], fill='#FF6B6B', outline='#4ECDC4', width=2)
    # Треугольник
    draw2.polygon([(200, 150), (220, 180), (240, 150)], fill='#FFE66D')
    
    draw2.text((100, 20), "Shapes", fill='white', font=font)
    img2.save(f"{demo_dir}/shapes.webp", 'WEBP', quality=85)
    
    # Изображение 3: Текст с эффектами
    img3 = Image.new('RGB', (300, 200), color='#45B7D1')
    draw3 = ImageDraw.Draw(img3)
    
    # Фон с узором
    for i in range(0, 300, 20):
        draw3.line([(i, 0), (i, 200)], fill='#2C3E50', width=1)
    for i in range(0, 200, 20):
        draw3.line([(0, i), (300, i)], fill='#2C3E50', width=1)
    
    # Текст с тенью
    text = "TEXT EFFECTS"
    draw3.text((52, 82), text, fill='#34495E', font=font)
    draw3.text((50, 80), text, fill='#ECF0F1', font=font)
    
    img3.save(f"{demo_dir}/text_effects.webp", 'WEBP', quality=95)
    
    print(f"[OK] Создано 3 демо изображения в папке {demo_dir}/")
    return demo_dir

def run_demo_conversions(demo_dir):
    """Запускает демонстрационные конвертации"""
    print("\n[INFO] Демонстрация конвертации...")
    
    # 1. Базовая конвертация
    print("\n[DEMO] Демо 1: Базовая конвертация")
    result = subprocess.run([
        "python", "webp2png.py", 
        f"{demo_dir}/gradient.webp"
    ], capture_output=True, text=True)
    
    if result.returncode == 0:
        print("[OK] Базовая конвертация работает")
    else:
        print("[ERROR] Ошибка в базовой конвертации")
        print(f"Ошибка: {result.stderr}")
    
    # 2. Конвертация с удалением
    print("\n[DEMO] Демо 2: Конвертация с удалением исходного")
    result = subprocess.run([
        "python", "webp2png.py", 
        "--delete", 
        f"{demo_dir}/shapes.webp"
    ], capture_output=True, text=True)
    
    if result.returncode == 0:
        print("[OK] Конвертация с удалением работает")
    else:
        print("[ERROR] Ошибка в конвертации с удалением")
        print(f"Ошибка: {result.stderr}")
    
    # 3. Конвертация всей папки
    print("\n[DEMO] Демо 3: Конвертация всей папки")
    result = subprocess.run([
        "python", "webp2png.py", 
        demo_dir
    ], capture_output=True, text=True)
    
    if result.returncode == 0:
        print("[OK] Конвертация папки работает")
    else:
        print("[ERROR] Ошибка в конвертации папки")
        print(f"Ошибка: {result.stderr}")

def show_results(demo_dir):
    """Показывает результаты конвертации"""
    print("\n[INFO] Результаты конвертации:")
    
    if os.path.exists(demo_dir):
        files = os.listdir(demo_dir)
        webp_files = [f for f in files if f.endswith('.webp')]
        png_files = [f for f in files if f.endswith('.png')]
        
        print(f"[INFO] WebP файлов: {len(webp_files)}")
        for f in webp_files:
            size = os.path.getsize(os.path.join(demo_dir, f))
            print(f"   • {f} ({size} байт)")
        
        print(f"[INFO] PNG файлов: {len(png_files)}")
        for f in png_files:
            size = os.path.getsize(os.path.join(demo_dir, f))
            print(f"   • {f} ({size} байт)")

def cleanup_demo(demo_dir):
    """Очищает демо файлы"""
    print(f"\n[INFO] Очистка демо файлов...")
    if os.path.exists(demo_dir):
        import shutil
        shutil.rmtree(demo_dir)
        print(f"[OK] Папка {demo_dir} удалена")

def main():
    """Основная функция демонстрации"""
    print("[DEMO] Демонстрация WebP to PNG конвертера")
    print("=" * 50)
    
    try:
        # Создаем демо изображения
        demo_dir = create_demo_images()
        
        # Запускаем демо конвертации
        run_demo_conversions(demo_dir)
        
        # Показываем результаты
        show_results(demo_dir)
        
        print("\n[SUCCESS] Демонстрация завершена успешно!")
        
        # Спрашиваем пользователя о сохранении файлов
        response = input("\n❓ Удалить демо файлы? (y/n): ").lower().strip()
        if response in ['y', 'yes', 'да', 'д']:
            cleanup_demo(demo_dir)
        else:
            print(f"[INFO] Демо файлы сохранены в папке {demo_dir}/")
            
    except Exception as e:
        print(f"[ERROR] Ошибка в демонстрации: {str(e)}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)

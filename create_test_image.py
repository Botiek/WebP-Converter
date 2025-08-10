#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Создание тестового WebP изображения для проверки конвертера
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_test_webp():
    """Создает красивое тестовое WebP изображение"""
    
    # Создаем изображение 400x300 пикселей
    width, height = 400, 300
    img = Image.new('RGB', (width, height), color='#4A90E2')
    
    # Добавляем градиент
    draw = ImageDraw.Draw(img)
    for y in range(height):
        # Создаем градиент от синего к белому
        r = int(74 + (255 - 74) * y / height)
        g = int(144 + (255 - 144) * y / height)
        b = int(226 + (255 - 226) * y / height)
        color = (r, g, b)
        draw.line([(0, y), (width, y)], fill=color)
    
    # Добавляем текст
    try:
        # Пытаемся использовать системный шрифт
        font = ImageFont.truetype("arial.ttf", 36)
    except:
        try:
            font = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", 36)
        except:
            # Используем стандартный шрифт
            font = ImageFont.load_default()
    
    text = "Test WebP Image"
    text_bbox = draw.textbbox((0, 0), text, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]
    
    # Центрируем текст
    x = (width - text_width) // 2
    y = (height - text_height) // 2
    
    # Добавляем тень
    draw.text((x+2, y+2), text, fill='#2C3E50', font=font)
    draw.text((x, y), text, fill='white', font=font)
    
    # Добавляем рамку
    draw.rectangle([(10, 10), (width-10, height-10)], outline='white', width=3)
    
    # Сохраняем как WebP
    filename = "test_image.webp"
    img.save(filename, 'WEBP', quality=85)
    
    print(f"[INFO] Создан тестовый WebP файл: {filename}")
    print(f"[INFO] Размер: {os.path.getsize(filename)} байт")
    print(f"[INFO] Размеры: {width}x{height} пикселей")
    
    return filename

if __name__ == "__main__":
    create_test_webp()

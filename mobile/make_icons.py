#!/usr/bin/env python3
"""生成 PWA 图标"""
from PIL import Image, ImageDraw
import os

def create_icon(size, path):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 背景圆角矩形
    margin = size // 10
    draw.rounded_rectangle(
        [margin, margin, size-margin, size-margin],
        radius=size//4,
        fill=(15, 15, 26)
    )
    
    # 机器人图标
    robot_size = size // 3
    robot_x = (size - robot_size) // 2
    robot_y = size // 3
    
    # 头部
    draw.rounded_rectangle(
        [robot_x, robot_y, robot_x+robot_size, robot_y+robot_size//2],
        radius=robot_size//6,
        fill=(233, 69, 96)
    )
    
    # 眼睛
    eye_size = robot_size // 8
    draw.ellipse([robot_x+robot_size//4, robot_y+robot_size//3, 
                  robot_x+robot_size//4+eye_size, robot_y+robot_size//3+eye_size],
                 fill=(255, 255, 255))
    draw.ellipse([robot_x+robot_size//2+robot_size//8, robot_y+robot_size//3,
                  robot_x+robot_size//2+robot_size//8+eye_size, robot_y+robot_size//3+eye_size],
                 fill=(255, 255, 255))
    
    img.save(path)

if __name__ == '__main__':
    os.makedirs('icons', exist_ok=True)
    for size in [72, 96, 128, 144, 192, 512]:
        create_icon(size, f'icons/icon-{size}.png')
        print(f'Created icon-{size}.png')
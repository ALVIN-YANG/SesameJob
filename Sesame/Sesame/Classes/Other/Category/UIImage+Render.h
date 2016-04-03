//
//  UIImage+Render.h
//  01-BuDeJie
//
//  Created by 杨卢青 on 16/2/14.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Render)
+ (UIImage *)imageWithOriginalRender:(NSString *)imageName;

// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

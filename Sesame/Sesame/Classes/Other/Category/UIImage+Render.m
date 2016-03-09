//
//  UIImage+Render.m
//  01-BuDeJie
//
//  Created by 杨卢青 on 16/2/14.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "UIImage+Render.h"

@implementation UIImage (Render)
+ (UIImage *)imageWithOriginalRender:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end

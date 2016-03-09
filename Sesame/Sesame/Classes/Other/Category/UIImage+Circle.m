//
//  UIImage+Circle.m
//  01-BS搭建
//
//  Created by 杨卢青 on 16/2/15.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)

- (instancetype)ylq_circleImage{
    //1.开启图形上下图
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    //2.描述裁剪路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //3.addclip
    [path addClip];
    //4.drawAtPoint
    [self drawAtPoint:CGPointZero];
    //5.getImageFromCurrentImageContext 获取Image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //6.endImagecontext
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)ylq_circleImageNamed:(NSString *)name{
    return [[self imageNamed:name] ylq_circleImage];
}
@end

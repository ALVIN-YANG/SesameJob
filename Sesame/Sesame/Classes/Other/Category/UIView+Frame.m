//
//  UIView+Frame.m
//  Sesame
//
//  Created by 杨卢青 on 16/1/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (BOOL)ylq_coincideWithView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    //把坐标系转换成window的, 同一坐标系
    CGRect rect1 = [self convertRect:self.bounds toView:nil];
    CGRect rect2 = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(rect1, rect2);
}
- (CGFloat)ylq_height
{
    return self.frame.size.height;
}
- (void)setYlq_height:(CGFloat)ylq_height
{
    CGRect frame = self.frame;
    frame.size.height = ylq_height;
    self.frame = frame;
}
- (CGFloat)ylq_width
{
     return self.frame.size.width;
}

- (void)setYlq_width:(CGFloat)ylq_width
{
    CGRect frame = self.frame;
    frame.size.width = ylq_width;
    self.frame = frame;
}

- (void)setYlq_x:(CGFloat)ylq_x
{
    CGRect frame = self.frame;
    frame.origin.x = ylq_x;
    self.frame = frame;

}
- (CGFloat)ylq_x
{
    return self.frame.origin.x;
}

- (void)setYlq_y:(CGFloat)ylq_y
{
    CGRect frame = self.frame;
    frame.origin.y = ylq_y;
    self.frame = frame;
}
- (CGFloat)ylq_y
{
    return self.frame.origin.y;
}
- (CGFloat)ylq_center_X{
    return self.center.x;
}
- (CGFloat)ylq_center_Y{
    return self.center.y;
}
- (void)setYlq_center_X:(CGFloat)ylq_center_X{
    CGPoint center = self.center;
    center.x = ylq_center_X;
    self.center = center;
}
- (void)setYlq_center_Y:(CGFloat)ylq_center_Y{
    CGPoint center = self.center;
    center.y = ylq_center_Y;
    self.center = center;
}
@end

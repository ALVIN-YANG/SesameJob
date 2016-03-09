//
//  UIView+Frame.h
//  Sesame
//
//  Created by 杨卢青 on 16/1/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property CGFloat ylq_x;
@property CGFloat ylq_y;
@property CGFloat ylq_width;
@property CGFloat ylq_height;
@property CGFloat ylq_center_X;
@property CGFloat ylq_center_Y;
//是否重合 于 屏幕
- (BOOL)ylq_coincideWithView:(UIView *)view;
@end

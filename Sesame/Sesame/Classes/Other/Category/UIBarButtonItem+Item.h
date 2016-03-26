//
//  UIBarButtonItem+Item.h
//  01-BS搭建
//
//  Created by 杨卢青 on 16/1/19.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

+ (UIBarButtonItem *)createItemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)createItemWithImage:(UIImage *)image highImage:(UIImage *)selImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;
@end

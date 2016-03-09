//
//  UITextField+Placeholder.m
//  01-BS搭建
//
//  Created by 杨卢青 on 16/1/22.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>

@implementation UITextField (Placeholder)


#pragma mark - 重写setget方法
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    //设置关联, 保存属性到系统类, 1就是nonatomic
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, 1);
    //KeyPath 可以用点
    UILabel *placeholderLabel = [self valueForKeyPath:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}
- (UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

#pragma mark - 修改字体后赋值颜色方法
- (void)ylq_setplaceholder:(NSString *)placeholder{
    //交换后调用的是原系统方法
    [self ylq_setplaceholder:placeholder];
    //重新赋值颜色
    self.placeholderColor = self.placeholderColor;
}

#pragma mark - 与系统方法交换,+load
+ (void)load{
    //拿到需要交换的两个方法
    Method setplaceholderMethod = class_getClassMethod(self, @selector(setPlaceholder:));
    Method ylq_setplaceholderMethod = class_getClassMethod(self, @selector(ylq_setplaceholder:));
    //交换
    method_exchangeImplementations(setplaceholderMethod, ylq_setplaceholderMethod);
}

@end

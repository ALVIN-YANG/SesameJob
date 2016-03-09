//
//  UIView+Init.m
//  01-BS搭建
//
//  Created by 杨卢青 on 16/2/20.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "UIView+Init.h"

@implementation UIView (Init)

+ (instancetype)ylq_viewFromXib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}
@end

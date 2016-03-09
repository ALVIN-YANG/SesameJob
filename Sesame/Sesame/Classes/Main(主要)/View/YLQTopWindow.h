//
//  YLQTopWindow.h
//  Sesame
//
//  Created by 杨卢青 on 16/3/9.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLQTopWindow : UIWindow

+ (void)showWithStatusBarClickWithBlock:(void (^)())block;

+ (void)setStatusBarHidden:(BOOL)hidden;
+ (void)setStatusBarStyle:(UIStatusBarStyle)style;
@end

//
//  YLQTopWindow.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/9.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQTopWindow.h"

@interface YLQTopWindowController : UIViewController
@property (nonatomic, strong) void (^StatusBarClick)();
@end

static BOOL hidden_;
static UIStatusBarStyle style_;

@implementation YLQTopWindowController
//让控制器来管理事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.StatusBarClick) self.StatusBarClick();
}

#pragma mark - 状态栏控制
- (BOOL)prefersStatusBarHidden{
    return hidden_;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return style_;
}
//状态栏刷新动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}
@end


@implementation YLQTopWindow
static YLQTopWindow *window_ ;
+ (void)showWithStatusBarClickWithBlock:(void (^)())block{
    if(window_) return;
    window_ = [[YLQTopWindow alloc] init];
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    window_.hidden = NO;
    
    //设置根控制器
    YLQTopWindowController *topVC = [[YLQTopWindowController alloc] init];
    topVC.view.backgroundColor = [UIColor clearColor];
    topVC.view.frame = [UIApplication sharedApplication].statusBarFrame;
    topVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topVC.StatusBarClick = block;
    window_.rootViewController = topVC;
}

+ (void)setStatusBarHidden:(BOOL)hidden{
    hidden_ = hidden;
    [UIView animateWithDuration:0.3 animations:^{
        [window_.rootViewController setNeedsStatusBarAppearanceUpdate];
    }];
}

+ (void)setStatusBarStyle:(UIStatusBarStyle)style{
    style_ = style;
    [UIView animateWithDuration:0.3 animations:^{
        [window_.rootViewController setNeedsStatusBarAppearanceUpdate];
    }];
    
}

/**
 *  当用户点击屏幕时，首先会调用这个方法，询问谁来处理这个点击事件
 *
 *  @return 如果返回nil，代表当前window不处理这个点击事件
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 如果触摸点的y值 > 20，超出状态栏不处理
    if (point.y > 20) return nil;
    
    // 如果触摸点的y值 <= 20，点击有效
    return [super hitTest:point withEvent:event];
}
@end

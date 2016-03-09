//
//  YLQTabBar.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/8.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQTabBar.h"

@interface YLQTabBar()
@property (nonatomic, weak) UIButton *plusButton;
@property (nonatomic, assign)NSInteger previousClickedTabBarButtonTag;
@end
@implementation YLQTabBar

#pragma mark - 懒加载Button
- (UIButton *)plusButton{
    if (!_plusButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        //一定要设置尺寸
        [btn sizeToFit];
        [self addSubview:btn];
        _plusButton = btn;
    }
    return _plusButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //获取子控件数
    NSInteger count = self.items.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.ylq_width / (count + 1);
    CGFloat h = self.ylq_height;
    //遍历所有子控件 空出位置
    int i = 0;
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 2) {
                i += 1;
            }
            x = i * w;
            //  设置UITabBarButton位置
            tabBarButton.frame = CGRectMake(x, y, w, h);
            tabBarButton.tag = i;
            i++;
            
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    // 设置加号按钮位置
    self.plusButton.center = CGPointMake(YLQScreenW * 0.5, h * 0.5 - 6);
}

#pragma mark - tabBarButtonClick
- (void)tabBarButtonClick:(UIControl *)tabBarButton{
    if (self.previousClickedTabBarButtonTag == tabBarButton.tag) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:YLQTabBarButtonDidRepeatClickNotification object:nil];
    }
    
}
@end

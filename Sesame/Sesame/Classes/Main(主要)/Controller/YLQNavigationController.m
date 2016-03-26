//
//  YLQNavigationController.m
//  Sesame
//
//  Created by 杨卢青 on 16/1/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQNavigationController.h"

@interface YLQNavigationController()<UIGestureRecognizerDelegate>

@end

@implementation YLQNavigationController
#pragma mark - load
+ (void)load{
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *titleAtrr = [NSMutableDictionary dictionary];
    titleAtrr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navigationBar setTitleTextAttributes:titleAtrr];
    
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - viewDidload
/*
 <UIScreenEdgePanGestureRecognizer: 0x7fcf9bc7b3d0; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fcf9bc6f120>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fcf9bc7afc0>)>>
 */
- (void)viewDidLoad{
    [super viewDidLoad];
    //拿到系统调用手势的target
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    //    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
    //    YLQLog(@"%@", self.interactivePopGestureRecognizer);
}

#pragma mark - push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //要判断是不是根控制器,  viewController
    
    if (self.childViewControllers.count > 0) {
        //不是跟控制器就隐藏底部条
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    }
    //调用父类的push
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

#pragma mark - GestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //    return self.childViewControllers.count > 0;
    
    
    return self.childViewControllers.count > 1;
}
@end


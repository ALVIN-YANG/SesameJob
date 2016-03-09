//
//  YLQTabBarController.m
//  Sesame
//
//  Created by 杨卢青 on 16/1/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQTabBarController.h"
#import "YLQNavigationController.h"
#import "HomeViewController.h"
#import "SiftViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "YLQTabBar.h"

@interface YLQTabBarController ()

@end

@implementation YLQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子控制器
    [self setupAllChildViewController];
    //设置TabBar
    [self setupTabBarButton];
    //自定义TabBar
    [self setupTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load
+ (void)load{
    //获取全局的tabBarItem, 只是self对象的item
    //吖峥开发时改通讯录的时候把系统的也改了
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    //创建富文本属性字典
    //1.选中状态下的字体颜色
    NSMutableDictionary *barAtrr = [NSMutableDictionary dictionary];
    barAtrr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [tabBarItem setTitleTextAttributes:barAtrr forState:UIControlStateSelected];
    //2.普通状态下的字体大小
    NSMutableDictionary *barAtrr1 = [NSMutableDictionary dictionary];
    barAtrr1[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [tabBarItem setTitleTextAttributes:barAtrr1 forState:UIControlStateNormal];
}

#pragma mark - setupAllChildViewController
- (void)setupAllChildViewController{
    //主页
    HomeViewController *vc1 = [[HomeViewController alloc] init];
    YLQNavigationController *nv1 = [[YLQNavigationController alloc] initWithRootViewController:vc1];
    [self addChildViewController:nv1];
    //筛选
    SiftViewController *vc2 = [[SiftViewController alloc] init];
    YLQNavigationController *nv2 = [[YLQNavigationController alloc] initWithRootViewController:vc2];
    [self addChildViewController:nv2];
    //消息
    MessageViewController *vc3 = [[MessageViewController alloc] init];
    YLQNavigationController *nv3 = [[YLQNavigationController alloc] initWithRootViewController:vc3];
    [self addChildViewController:nv3];
    //我
    MineViewController *vc4 = [[MineViewController alloc] init];
    YLQNavigationController *nv4 = [[YLQNavigationController alloc] initWithRootViewController:vc4];
    [self addChildViewController:nv4];
    
}

#pragma mark - setupTabBarButton
- (void)setupTabBarButton{
    //主页
    YLQNavigationController *nv1 = self.childViewControllers[0];
    nv1.tabBarItem.title = @"首页";
    nv1.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    nv1.tabBarItem.selectedImage = [UIImage imageWithOriginalRender:@"tabbar_home_highlighted"];
    //全部
    YLQNavigationController *nv2 = self.childViewControllers[1];
    nv2.tabBarItem.title = @"全部";
    nv2.tabBarItem.image = [UIImage imageNamed:@"latest_parttime"];
    nv2.tabBarItem.selectedImage = [UIImage imageWithOriginalRender:@"latest_parttime_hl"];
    //消息
    YLQNavigationController *nv3 = self.childViewControllers[2];
    nv3.tabBarItem.title = @"消息";
    nv3.tabBarItem.image = [UIImage imageNamed:@"miao"];
    nv3.tabBarItem.selectedImage = [UIImage imageWithOriginalRender:@"miao_hl"];
    //我
    YLQNavigationController *nv4 = self.childViewControllers[3];
    nv4.tabBarItem.title = @"我";
    nv4.tabBarItem.image = [UIImage imageNamed:@"personal_center"];
    nv4.tabBarItem.selectedImage = [UIImage imageWithOriginalRender:@"personal_center_hl"];
}

#pragma mark - 自定义tabBar
- (void)setupTabBar
{
    // UITabBar 换成 YLQTabBar  setvalue可以给私有属性赋值,可以给只读属性赋值
    YLQTabBar *tabBar = [[YLQTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
}
@end

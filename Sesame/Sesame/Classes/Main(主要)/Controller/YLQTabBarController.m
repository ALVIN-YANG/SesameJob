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
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([MessageViewController class]) bundle:nil];
    MessageViewController *MiaoVC = [storyBoard instantiateInitialViewController];
    YLQNavigationController *nv3 = [[YLQNavigationController alloc] initWithRootViewController:MiaoVC];
    [self addChildViewController:nv3];
    //显示信息提醒
    [MiaoVC loadConversationList];
    //我
    MineViewController *vc4 = [[UIStoryboard storyboardWithName:NSStringFromClass([MineViewController class]) bundle:nil] instantiateInitialViewController];
    YLQNavigationController *nv4 = [[YLQNavigationController alloc] initWithRootViewController:vc4];
    [self addChildViewController:nv4];
    
//    //我
//    MineViewController *vc5 = [[UIStoryboard storyboardWithName:NSStringFromClass([MineViewController class]) bundle:nil] instantiateInitialViewController];
//    YLQNavigationController *nv5 = [[YLQNavigationController alloc] initWithRootViewController:vc5];
//    [self addChildViewController:nv5];
    
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
    nv2.tabBarItem.title = @"工作";
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
    
//    //我
//    YLQNavigationController *nv5 = self.childViewControllers[4];
//    nv5.tabBarItem.title = @"我";
//    nv5.tabBarItem.image = [UIImage imageNamed:@"personal_center"];
//    nv5.tabBarItem.selectedImage = [UIImage imageWithOriginalRender:@"personal_center_hl"];
}

#pragma mark - 自定义tabBar
- (void)setupTabBar
{
    // UITabBar 换成 YLQTabBar  setvalue可以给私有属性赋值,可以给只读属性赋值
    YLQTabBar *tabBar = [[YLQTabBar alloc] init];
    [tabBar.plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)plusButtonClick
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = UIColorFromHex(0xDE1400);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 350, 200)];
    [label setPreferredMaxLayoutWidth:300];
    [label setText:@"Created by 杨卢青 \n\n      on 2016"];
    [label setTextColor:[UIColor whiteColor]];
    label.numberOfLines = 0;
    label.ylq_x = self.view.ylq_width * 0.04;
    label.ylq_y = self.view.center.y - 150;
//    label.center = self.view.center;
//    label.ylq_width = 300;
//    [label sizeToFit];
//    [label setEnabled:YES];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:30]];
    [vc.view addSubview:label];
    vc.view.frame = self.view.frame;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBack)];
    [vc.view addGestureRecognizer:tapGesture];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)touchBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

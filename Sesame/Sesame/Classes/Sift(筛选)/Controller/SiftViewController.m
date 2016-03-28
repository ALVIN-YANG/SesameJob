//
//  SiftViewController.m
//  Sesame
//
//  Created by 杨卢青 on 16/1/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SiftViewController.h"
#import "YLQTitleButton.h"
#import "TotalJobController.h"
#import "WaitJobController.h"
#import "AdmitJobController.h"
#import "WaitSalaryController.h"
#import "WaitReviewController.h"

@interface SiftViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIView *titleView;
@property (nonatomic, weak)YLQTitleButton *preSelectedBtn;
@property (nonatomic, weak)UIView *subLine;
@end

@implementation SiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setNavigationBar];
    
    //设置ScrollView
    [self setupScrollView];
    //设置title
    [self setupTitle];
    //设置子控制器
    [self setupViewController];
    //设置下划线
    [self setupSubLine];
    
    self.scrollView.delegate = self;
    
    
}

#pragma mark - setNavigationBar
- (void)setNavigationBar {
    self.navigationItem.title = @"相关工作";
}



#pragma mark - setupScrollView
- (void)setupScrollView{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroll.backgroundColor = [UIColor cyanColor];
    self.scrollView = scroll;
    [self.view addSubview:scroll];
    
}

#pragma mark - setupTitle
- (void)setupTitle{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 35)];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    self.titleView = view;
    [self.view addSubview:view];
    [self setupButtons];
    
}

#pragma mark - setupButtons
- (void)setupButtons{
    NSArray *btns = @[@"全部", @"待录取", @"已录取", @"待发工资", @"待评价"];
    NSInteger count = btns.count;
    CGFloat btnX ,btnW;
    for (NSInteger i = 0; i < count; i++) {
        btnW = self.titleView.bounds.size.width / count;
        btnX = i * btnW;
        
        YLQTitleButton *btn = [[YLQTitleButton alloc] init];
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:btn];
        btn.frame = CGRectMake(btnX, 0, btnW, self.titleView.bounds.size.height);
        btn.tag = i;
        [btn setTitle:btns[i] forState:UIControlStateNormal];
    }
}

- (void)titleBtnClick:(YLQTitleButton *)btn{
    //如果是重复点击
    if (self.preSelectedBtn == btn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YLQTitleBarButtonDidRepeatClickNotification object:nil];
    }
    [self dealTitleButtonClick:btn];
}

- (void)dealTitleButtonClick:(YLQTitleButton *)titleButton{
    
    
    //切换按钮状态
    self.preSelectedBtn.selected = NO;
    titleButton.selected = YES;
    self.preSelectedBtn = titleButton;
    
    [UIView animateWithDuration:0.25 animations:^{
        //下划线
        [titleButton.titleLabel sizeToFit];
        self.subLine.ylq_width = titleButton.titleLabel.ylq_width;
        self.subLine.ylq_center_X = titleButton.ylq_center_X;
        //scroll
        CGFloat offsetX = titleButton.tag * self.scrollView.ylq_width;
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    }];
    
}

#pragma mark - setupSubLine
- (void)setupSubLine{
    YLQTitleButton *firstBtn = self.titleView.subviews.firstObject;
    UIView *subLine = [[UIView alloc] init];
    subLine.frame = CGRectMake(0, self.titleView.ylq_height - 2, 70, 2);
    subLine.backgroundColor = [firstBtn titleColorForState:UIControlStateSelected];
    [self.titleView addSubview:subLine];
    self.subLine = subLine;
    //默认选中第一个
    firstBtn.selected = YES;
    self.preSelectedBtn = firstBtn;
    
    [firstBtn.titleLabel sizeToFit];
    self.subLine.ylq_width = firstBtn.titleLabel.ylq_width + 10;
    self.subLine.ylq_center_X = firstBtn.ylq_center_X;
    
}

#pragma mark - setupViewController
- (void)setupViewController{
    [self addChildViewController:[[TotalJobController alloc] init]];
    [self addChildViewController:[[WaitJobController alloc] init]];
    [self addChildViewController:[[AdmitJobController alloc] init]];
    [self addChildViewController:[[WaitSalaryController alloc] init]];
    [self addChildViewController:[[WaitReviewController alloc] init]];
    
    //添加控制器的View到scrollView
    NSUInteger count = self.childViewControllers.count;
    for (NSInteger i = 0; i < count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        vc.view.ylq_x = i * self.scrollView.ylq_width;
        vc.view.ylq_y = 0;
        vc.view.ylq_height = self.scrollView.ylq_height;
        vc.view.ylq_width = self.scrollView.ylq_width;
        [self.scrollView addSubview:vc.view];
        //        NSLog(@"%ld",i);
    }
    //设置scrollView
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.ylq_width, 0);
    //    NSLog(@"%f", self.scrollView.contentSize.width);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //取消自动调整内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 按钮索引
    NSInteger index = scrollView.contentOffset.x / scrollView.ylq_width;
    
    // 找到按钮
    YLQTitleButton *titleButton = self.titleView.subviews[index];
    //    XMGTitleButton *titleButton = [self.titlesView viewWithTag:index];
    
    // 点击按钮
    [self dealTitleButtonClick:titleButton];
    
}



@end

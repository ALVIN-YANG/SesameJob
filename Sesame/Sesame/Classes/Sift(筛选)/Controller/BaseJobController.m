//
//  BaseJobController.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "BaseJobController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD.h>
#import "YLQHTTPSSessionManager.h"
#import "YLQRefreshHeader.h"
#import "YLQRefreshFooter.h"
#import "WeChatStylePlaceHolder.h"
#import <SDImageCache.h>
#import <CYLTableViewPlaceHolder.h>

@interface BaseJobController ()<CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate>
//请求管理者
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
//数据:模型数组,  不断更新数据, 要可变数组
@property (nonatomic, strong) NSMutableArray *itemArray;
//footer
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
@property (nonatomic, weak) UIView *footer;
@property (nonatomic, weak) UILabel *footerLabel;
//header
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;
@property (nonatomic, weak) UIView *header;
@property (nonatomic, weak) UILabel *headerLabel;

@end

@implementation BaseJobController

#pragma mark - 懒加载
- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView cyl_reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(YLQNavMaxY + YLQTitlesViewH, 0, YLQTabBarH, 0);
    
    //??
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = YLQColor(210, 210, 210)
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.estimatedRowHeight = 44;
    //对tabBarButton的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:YLQTabBarButtonDidRepeatClickNotification object:nil];
    //对title监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarButtonDidRepeatClick) name:YLQTitleBarButtonDidRepeatClickNotification object:nil];

    [self downUpdate];

}

#pragma mark - upDate
- (void)downUpdate{
    
    //header
    self.tableView.mj_header = [YLQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    //footer
    self.tableView.mj_footer = [YLQRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (void)loadNewTopics {
    //取消加载
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.mgr GET:@"baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        [self.tableView cyl_reloadData];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        //返回错误代码
        if (error.code == NSURLErrorCancelled) return;
//        [SVProgressHUD showErrorWithStatus:@"网络繁忙,稍后尝试"];
    }];
}

- (void)loadMoreTopics {
    //取消加载
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
   
    [self.mgr GET:@"baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        [self.tableView cyl_reloadData];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        //返回错误代码
        if (error.code == NSURLErrorCancelled) return;
//        [SVProgressHUD showErrorWithStatus:@"网络繁忙,稍后尝试"];
    }];
}

#pragma mark - tabBarButtonDidRepeatClick
- (void)tabBarButtonDidRepeatClick{
    
    //如果当前控制器View不在window上,直接返回
    //self.view.window 可以拿到所在控制器view在哪一个window上, 因为之前需要点击状态栏回到顶部, 多了一个window
    if(self.view.window == nil) return;
    //如果当前控制器的view与屏幕不重叠,直接返回
    if(![self.view ylq_coincideWithView:nil]) return;
    
    
    if(self.isHeaderRefreshing) return;
    //下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)titleBarButtonDidRepeatClick{
    [self tabBarButtonDidRepeatClick];
}

#pragma mark - CYLTableViewPlaceholderDelegate
- (UIView *)makePlaceHolderView {
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}


- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}

#pragma mark - WeChatStylePlaceHolderDelegate Method

- (void)emptyOverlayClicked:(id)sender {
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

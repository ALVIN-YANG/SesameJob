//
//  HomeViewController.m
//  Sesame
//
//  Created by 杨卢青 on 16/1/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "HomeViewController.h"
#import "YLQScrollPage.h"
#import "SecondView.h"
#import "RefreshView.h"
#import "YLQHomeTableView.h"
#import "YLQCellModel.h"
#import "YLQTableCell.h"
#import "YLQRefreshHeader.h"
#import "YLQRefreshFooter.h"
#import "YLQHTTPSSessionManager.h"
#import "FastJobViewController.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>



@interface HomeViewController ()<YLQScrollPageDelegate, UIScrollViewDelegate, UITableViewDelegate, SecondViewDelegate>

@property (nonatomic, strong) YLQScrollPage      * topScrollView;
@property (nonatomic, strong) YLQScrollPage      * midScrollView;
@property (nonatomic, weak) SecondView         * secondView;
@property (nonatomic, weak) RefreshView        * refreshView;

//请求管理者
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
//数据:模型数组,  不断更新数据, 要可变数组
@property (nonatomic, strong) NSMutableArray *itemArray;
//maxtime
@property (nonatomic, strong) NSString *maxtime;
//footer
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
//header
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;
@end

static NSString *const ID = @"cell";
static NSString *const Top = @"Top";
static NSString *const Second = @"Second";
static NSString *const Mid = @"Mid";
@implementation HomeViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"芝麻兼职";
    self.tableView.backgroundColor = YLQColor(210, 210, 210)
    [self setupTableView];
    [self downUpdate];
    //对tabBarButton的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:YLQTabBarButtonDidRepeatClickNotification object:nil];
    //对title监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarButtonDidRepeatClick) name:YLQTitleBarButtonDidRepeatClickNotification object:nil];
}

#pragma mark - 懒加载
- (SecondView *)secondView{
    if (!_secondView) {
        _secondView = [SecondView ylq_viewFromXib];
        _secondView.frame = CGRectMake(0, 0, YLQScreenW, 150);
    }
    return _secondView;
}

- (RefreshView *)refreshView{
    if (!_refreshView) {
        _refreshView = [RefreshView ylq_viewFromXib];
    }
    return _refreshView;
}

- (YLQScrollPage *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[YLQScrollPage alloc] init];
        _topScrollView.images = @[
                                 [UIImage imageNamed:@"image0"],
                                 [UIImage imageNamed:@"image1"],
                                 [UIImage imageNamed:@"image2"],
                                 [UIImage imageNamed:@"image3"]
                                 ];
        _topScrollView.delegate = self;
        _topScrollView.pageControl.pageIndicatorTintColor = [UIColor redColor];
        _topScrollView.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    }
    return _topScrollView;
}

- (YLQScrollPage *)midScrollView{
    if (!_midScrollView) {
        _midScrollView = [[YLQScrollPage alloc] init];
        _midScrollView.images = @[
                                  [UIImage imageNamed:@"image0"],
                                  [UIImage imageNamed:@"image1"],
                                  [UIImage imageNamed:@"image2"],
                                  [UIImage imageNamed:@"image3"]
                                  ];
        _midScrollView.delegate = self;
        _midScrollView.pageControl.pageIndicatorTintColor = [UIColor redColor];
        _midScrollView.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
        
    }
    return _midScrollView;
}

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}

#pragma mark - 时间监听
- (void)tabBarButtonDidRepeatClick{
    //如果当前控制器View不在window上,直接返回
    //self.view.window 可以拿到所在控制器view在哪一个window上
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

#pragma mark - setupTableView
- (void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLQTableCell class]) bundle:nil] forCellReuseIdentifier:ID];

}

#pragma mark - update
- (void)downUpdate{
    
    //header
    self.tableView.mj_header = [YLQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewJobMessage)];
    [self.tableView.mj_header beginRefreshing];
    //footer
    self.tableView.mj_footer = [YLQRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreJobMessage)];
}

- (void)loadNewJobMessage{
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    //拼接parameters
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self.mgr GET:@"http://capp.tanlu.cc/v130/job/detail?v=1.4.0&userid=&token=&data=%7B%0A%20%20%22jobid%22%20:%2083515%0A%7D" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [responseObject writeToFile:@"/Users/YLQ/Desktop/SesameJob/detail.plist" atomically:YES];
        [self.tableView reloadData];
        
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        //返回错误代码
        if (error.code == NSURLErrorCancelled) return;
        [SVProgressHUD showErrorWithStatus:@"网络繁忙,稍后尝试"];
    }];
}

- (void)loadMoreJobMessage{
    YLQLog(@"加载新数据");
}

#pragma mark - SecondViewDelegate



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3 ) {
        return 15;
    }else return 1;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell *topCell = [[UITableViewCell alloc] init];
        self.topScrollView.frame = CGRectMake(0, 0, YLQScreenW, 110);
        topCell.contentView.frame = CGRectMake(0, 0, YLQScreenW, 110);
        [topCell.contentView addSubview:_topScrollView];
        return topCell;
    }else if(indexPath.section == 1){
        UITableViewCell *secondCell = [[UITableViewCell alloc] init];
        secondCell.contentView.frame = CGRectMake(0, 0, YLQScreenW, 150);
        [secondCell.contentView addSubview:self.secondView];
        return secondCell;
    }else if(indexPath.section == 2){
        UITableViewCell *midCell = [[UITableViewCell alloc] init];
        self.midScrollView.frame = CGRectMake(0, 0, YLQScreenW, 80);
        midCell.contentView.frame = CGRectMake(0, 0, YLQScreenW, 80);
        [midCell.contentView addSubview:_midScrollView];
        return midCell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        return cell;
    }
}
//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return self.refreshView;
    }
    return nil;
}
//header高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 35;
    }
    return 0;
}
//footer高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 10;
    }
    return 0;
}
//cell高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else if(indexPath.section == 1){
        return 150;
    }else if(indexPath.section == 2){
        return 80;
    }else{
        return 80;
    }
}

@end

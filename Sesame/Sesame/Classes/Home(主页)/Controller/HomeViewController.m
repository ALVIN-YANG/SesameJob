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
#import "YLQDetailModel.h"
#import "YLQTableCell.h"
#import "YLQRefreshHeader.h"
#import "YLQRefreshFooter.h"
#import "YLQHTTPSSessionManager.h"
#import "FastJobViewController.h"
#import "DetailJobMessageController.h"
#import "TravelJobController.h"
#import "MiaoJobController.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>



@interface HomeViewController ()<YLQScrollPageDelegate, UIScrollViewDelegate, UITableViewDelegate, SecondViewDelegate>

@property (nonatomic, strong) YLQScrollPage      * topScrollView;
@property (nonatomic, strong) YLQScrollPage      * midScrollView;
@property (nonatomic, weak) SecondView         * secondView;
@property (nonatomic, weak) RefreshView        * refreshView;

@property (nonatomic, strong) DetailJobMessageController *DetailVC;
//请求管理者
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
//数据:模型数组,  不断更新数据, 要可变数组
@property (nonatomic, strong) NSMutableArray *itemArray;
// detailArray
@property (nonatomic, strong) NSMutableDictionary *detailArray;
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
        _secondView.delegate = self;
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
                                  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://image.store.tanlu.cc/images/banners/banner_20160321153701.jpg"]]],
                                 [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://image.store.tanlu.cc/images/banners/banner_20160323215143.jpg"]]],
                                 [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://image.store.tanlu.cc/images/banners/banner_20160311193834.jpg"]]],
                                  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://image.store.tanlu.cc/images/banners/banner_20160324172523.jpg"]]],
                                  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://image.store.tanlu.cc/images/banners/banner_20160309122903.jpg"]]]
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
                                  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.jianzhimao.com/message/guochengliang/1456903462166.jpg"]]],
                                  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.jianzhimao.com//message//guochengliang//1445824521745.jpg"]]],
                                  
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

#pragma mark - 事件监听
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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self.mgr GET:@"http://capp.tanlu.cc/v140/job/listByHome?v=1.4.2&userid=579032&token=061cb5c89e70e4334233036bfe83454a&data=%7B%0A%20%20%22cityid%22%20:%20%2228%22,%0A%20%20%22sort%22%20:%20%22%22,%0A%20%20%22lo%22%20:%20%22116.450111%22,%0A%20%20%22cityname%22%20:%20%22%E5%8C%97%E4%BA%AC%E5%B8%82%22,%0A%20%20%22workdates%22%20:%20%5B%0A%0A%20%20%5D,%0A%20%20%22size%22%20:%20%2220%22,%0A%20%20%22settlecircleid%22%20:%20%22%22,%0A%20%20%22la%22%20:%20%2239.927669%22,%0A%20%20%22page%22%20:%201,%0A%20%20%22jobtypeid%22%20:%20%22%22%0A%7D" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [responseObject writeToFile:@"/Users/YLQ/Desktop/SesameJob/detail.plist" atomically:YES];
        self.itemArray = [YLQCellModel mj_objectArrayWithKeyValuesArray:responseObject[@"jobs"]];
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
    [self.mgr GET:@"http://capp.tanlu.cc/v140/job/listByHome?v=1.4.2&userid=579032&token=061cb5c89e70e4334233036bfe83454a&data=%7B%0A%20%20%22cityid%22%20:%20%2228%22,%0A%20%20%22sort%22%20:%20%22%22,%0A%20%20%22lo%22%20:%20%22116.450111%22,%0A%20%20%22cityname%22%20:%20%22%E5%8C%97%E4%BA%AC%E5%B8%82%22,%0A%20%20%22workdates%22%20:%20%5B%0A%0A%20%20%5D,%0A%20%20%22size%22%20:%20%2220%22,%0A%20%20%22settlecircleid%22%20:%20%22%22,%0A%20%20%22la%22%20:%20%2239.927669%22,%0A%20%20%22page%22%20:%201,%0A%20%20%22jobtypeid%22%20:%20%22%22%0A%7D" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        [responseObject writeToFile:@"/Users/YLQ/Desktop/SesameJob/detail.plist" atomically:YES];
        //加载新数据,  拼接到旧数据
        NSArray *moreData = [YLQCellModel mj_objectArrayWithKeyValuesArray:responseObject[@"jobs"]];
        [self.itemArray addObjectsFromArray:moreData];
        [self.tableView reloadData];
        
        //结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        //返回错误代码
        if (error.code == NSURLErrorCancelled) return;
        [SVProgressHUD showErrorWithStatus:@"网络繁忙,稍后尝试"];
    }];
}

#pragma mark - SecondViewDelegate
- (void)fastJobButtonClick
{
//    NSLog(@"点击了第一个Button");
    UIWebView *firstWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, YLQScreenW, YLQScreenH - 64)];
    firstWeb.scalesPageToFit = YES;
    [firstWeb setDataDetectorTypes:UIDataDetectorTypePhoneNumber];
    FastJobViewController *fastVC = [[FastJobViewController alloc] init];
    [fastVC.view addSubview:firstWeb];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.tanlu.cc/job/themesList?themeId=905&source=app&tla=39.927669&tlo=116.450111&source=ios"]];
    [firstWeb loadRequest:request];
    [self.navigationController pushViewController:fastVC animated:YES];
}

- (void)miaoJobButtonClick
{
//    NSLog(@"点击了第二个Button");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([MiaoJobController class]) bundle:nil];
    MiaoJobController *MiaoVC = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:MiaoVC animated:YES];
}

- (void)nearJobButtonClick
{
    NSLog(@"点击了第三个Button");
}

- (void)travelJobButtonClick
{
//    NSLog(@"点击了第四个Button");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([TravelJobController class]) bundle:nil];
    TravelJobController *TravelVC = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:TravelVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3 ) {
        return self.itemArray.count;
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
        
        YLQTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.cellModel = self.itemArray[indexPath.row];
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([DetailJobMessageController class]) bundle:nil];
    DetailJobMessageController *DetailVC = [storyBoard instantiateInitialViewController];
    //加载职位详情页面数据
    NSString *str = @"http://capp.tanlu.cc/v140/job/detail?v=1.4.2&userid=579032&token=061cb5c89e70e4334233036bfe83454a&data=%7B%0A%20%20%22jobid%22%20:%2089891%0A%7D";
    str = [str stringByReplacingOccurrencesOfString:@"2089891" withString:[NSString stringWithFormat:@"%zd", 2089891 + indexPath.row]];

    [self.mgr GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YLQDetailModel *model = _itemArray[indexPath.row];
        DetailVC.model = [YLQDetailModel mj_objectWithKeyValues:responseObject[@"jobdetail"]];
        DetailVC.model.distance = model.distance;
        [self.navigationController pushViewController:DetailVC animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //返回错误代码
        if (error.code == NSURLErrorCancelled) return;
        [SVProgressHUD showErrorWithStatus:@"网络繁忙,稍后尝试"];
    }];
    
}

#pragma mark - ScrollPageDelegate
- (void)infiniteScrollView:(YLQScrollPage *)scrollView didSelectItemAtIndex:(NSInteger)index
{
    UIWebView *firstWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, YLQScreenW, YLQScreenH - 64)];
    firstWeb.scalesPageToFit = YES;
    [firstWeb setDataDetectorTypes:UIDataDetectorTypePhoneNumber];
    FastJobViewController *fastVC = [[FastJobViewController alloc] init];
    [fastVC.view addSubview:firstWeb];
    NSURL *url = [[NSURL alloc] init];
        switch (index) {
            case 0:
                url = [NSURL URLWithString:@"http://m.tanlu.cc/article/detail?id=35&source=ios&userid=579032"];
                break;
            case 1:
                url = [NSURL URLWithString:@"http://m.tanlu.cc/job/detail/81009.html?jobid=81009&cityId=28&tlo=116.450111&tla=39.927669&source=ios"];
                break;
            case 2:
                url = [NSURL URLWithString:@"http://mp.weixin.qq.com/s?__biz=MjM5NzM4MDU3Nw==&mid=403307159&idx=4&sn=823c3793ee6449c2ff9b64b41b5c1562"];
                break;
            case 3:
                url = [NSURL URLWithString:@"http://m.tanlu.cc/article/detail?id=37&sharesource=android&cityId=28&tlo=116.450111&tla=39.927669&source=ios"];
                break;
            case 4:
                url = [NSURL URLWithString:@"http://m.tanlu.cc/article/detail?id=25&sharesource=android&cityId=28&tlo=116.450111&tla=39.927669&source=ios"];
                break;
            default:
                break;
        }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [firstWeb loadRequest:request];
    [self.navigationController pushViewController:fastVC animated:YES];
    NSLog(@"%zd", index);
}

@end

//
//  SearchViewController.m
//  Sesame
//
//  Created by 杨卢青 on 16/5/20.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDBManage.h"

// 最大存储的搜索历史 条数
#define MAX_COUNT 5

@interface SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
/**
 *  搜索历史数据表单
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  数据集合
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  SearchBar
 */
@property (nonatomic, strong) UISearchBar *searchBar;
@end


@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    //初始化数据
    [self initData];
    
    [self setNavTitleView];
    
    [self initTableView];
}

#pragma mark - Helper
/**
 *  数据初始化
 */
- (void)initData
{
    self.dataArray = [[NSMutableArray alloc] init];
    //获取数据库里面的全部数据
    self.dataArray = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
}

/**
 *  设置导航搜索框
 */
- (void)setNavTitleView
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, 140, 30);
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入搜索内容";
    searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
}

/**
 *  设置搜索历史显示表格
 */
- (void)initTableView
{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.view.bounds;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    //清空历史搜索按钮
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 104)];
    UIButton *clearButton = [[UIButton alloc] init];
    clearButton.frame = CGRectMake(60, 60, self.view.frame.size.width - 120, 44);
    [clearButton setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor colorWithRed:242/256 green:242/256 blue:242/256 alpha:1] forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchDown];
    clearButton.layer.cornerRadius = 3;
    clearButton.layer.borderWidth = 0.5;
    clearButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [footerView addSubview:clearButton];
    [_tableView setTableFooterView:footerView];
}

/**
 *  清空搜索历史操作
 */
- (void)clearButtonClick{
    [[SearchDBManage shareSearchDBManage] deleteAllSearchModel];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate, dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        //没有历史数据时隐藏
        self.tableView.tableFooterView.hidden = YES;
    }else {
        //有历史数据时显示
        self.tableView.tableFooterView.hidden = NO;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    SearchModel *model = (SearchModel *)[self exchangeArray:_dataArray][indexPath.row];
    cell.textLabel.text = model.keyWord;
    cell.detailTextLabel.text = model.currentTime;
    return cell;
}
/**
 *  数组逆序
 *
 *  @param array 需要逆序的数组
 *
 *  @return 逆序后的输出
 */
- (NSMutableArray *)exchangeArray:(NSMutableArray *)array{
    NSInteger num = array.count;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i = num - 1; i >= 0; i --) {
        [temp addObject:[array objectAtIndex:i]];
        
    }
    return temp;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel *model = (SearchModel *)[self exchangeArray:self.dataArray][indexPath.row];
    
    self.searchBar.text = model.keyWord;
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

/**
 *  点击搜索时, 历史记录插入数据库
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self insterDBData:searchBar.text];
    
    //取消第一响应者状态, 键盘消失
    [searchBar resignFirstResponder];
}

/**
 *  点击取消按钮
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //插入数据库
    [self insterDBData:searchBar.text];
    [searchBar resignFirstResponder];
}

/**
 *  关键词插入数据库
 *
 *  @param keyword 关键词
 */
- (BOOL)insterDBData:(NSString *)keyword{
    if (keyword.length == 0) {
        return NO;
    }
    else{//搜索历史插入数据库
        //先删除数据库中相同的数据
        [self removeSameData:keyword];
        //再插入数据库
        [self moreThan20Data:keyword];
        // 读取数据库里面的数据
        self.dataArray = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
        [self.tableView reloadData];
        return YES;
    }
}

/**
 *  去除数据库中已有的相同的关键词
 *
 *  @param keyword 关键词
 */
- (void)removeSameData:(NSString *)keyword{
    NSMutableArray *array = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SearchModel *model = (SearchModel *)obj;
        if ([model.keyWord isEqualToString:keyword]) {
            [[SearchDBManage shareSearchDBManage] deleteSearchModelByKeyword:keyword];
        }
    }];
}

/**
 *  多余20条数据就把第0条去除
 *
 *  @param keyword 插入数据库的模型需要的关键字
 */
- (void)moreThan20Data:(NSString *)keyword{
    // 读取数据库里面的数据
    NSMutableArray *array = [[SearchDBManage shareSearchDBManage] selectAllSearchModel];
    
    if (array.count > MAX_COUNT - 1) {
        NSMutableArray *temp = [self moveArrayToLeft:array keyword:keyword]; // 数组左移
        [[SearchDBManage shareSearchDBManage] deleteAllSearchModel]; //清空数据库
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchModel *model = (SearchModel *)obj; // 取出 数组里面的搜索模型
            [[SearchDBManage shareSearchDBManage] insterSearchModel:model]; // 插入数据库
        }];
    }
    else if (array.count <= MAX_COUNT - 1){ // 小于等于19 就把第20条插入数据库
        [[SearchDBManage shareSearchDBManage] insterSearchModel:[SearchModel creatSearchModel:keyword currentTime:[self getCurrentTime]]];
    }
}

/**
 *  数组左移
 *
 *  @param array   需要左移的数组
 *  @param keyword 搜索关键字
 *
 *  @return 返回新的数组
 */
- (NSMutableArray *)moveArrayToLeft:(NSMutableArray *)array keyword:(NSString *)keyword{
    [array addObject:[SearchModel creatSearchModel:keyword currentTime:[self getCurrentTime]]];
    [array removeObjectAtIndex:0];
    return array;
}

/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
- (NSString *)getCurrentTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
@end

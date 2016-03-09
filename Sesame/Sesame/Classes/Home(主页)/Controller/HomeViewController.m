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
#import <Masonry.h>



@interface HomeViewController ()<YLQScrollPageDelegate, UIScrollViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) YLQScrollPage      * topScrollView;
@property (nonatomic, strong) YLQScrollPage      * midScrollView;
@property (nonatomic, weak) SecondView         * secondView;
@property (nonatomic, weak) RefreshView        * refreshView;
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
    [self setupTableView];
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

#pragma mark - setupTableView
- (void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLQTableCell class]) bundle:nil] forCellReuseIdentifier:ID];

}


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

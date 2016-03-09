//
//  YLQHomeTableView.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/8.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQHomeTableView.h"
#import "RefreshView.h"
@interface YLQHomeTableView ()<UITableViewDataSource>
@property (nonatomic, weak) RefreshView *refreshView;
@end

@implementation YLQHomeTableView

- (RefreshView *)refreshView{
    if (!_refreshView) {
        _refreshView = [RefreshView ylq_viewFromXib];
    }
    return _refreshView;
}
static NSString  * const ID = @"cell";

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3 ) {
        return 15;
    }else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //    cell.textLabel.text = @"是打发打发发";
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        
    
        return self.refreshView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 35;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else if(indexPath.section == 1){
        return 150;
    }else if(indexPath.section == 2){
        return 80;
    }else{
        return 40;
    }
}
@end

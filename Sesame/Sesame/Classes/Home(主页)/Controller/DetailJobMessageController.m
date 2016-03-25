//
//  DetailJobMessageController.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/25.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "DetailJobMessageController.h"
#import <UIImageView+WebCache.h>
#import "YLQDetailModel.h"

@interface DetailJobMessageController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *needCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *settletypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation DetailJobMessageController

#pragma mark - 重写数据set
- (void)setModel:(YLQDetailModel *)model {
    _model = model;
    self.titleLable.text = model.title;
    self.needCountLabel.text = [NSString stringWithFormat:@"招聘%@人", model.needcount];
    self.salaryLabel.text = model.salary;
    self.settletypeLabel.text = model.settletype;
    self.areaLabel.text = model.area;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"职位详情";
    //设置tableview的cell 间距 设置为10
    self.tableView.sectionFooterHeight = 10;
    self.tableView.sectionHeaderHeight = 0;
    //上面的间隔是tableview造成的 35 ,所以设置其contentInset
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



@end

//
//  DetailTableViewController.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "DetailTableViewController.h"
#import "YLQDetailModel.h"
#import <UIImageView+WebCache.h>

@interface DetailTableViewController()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *needCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *settletypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) UIView *bView;

@end
@implementation DetailTableViewController

- (void)setModel:(YLQDetailModel *)model{
    _model = model;
    self.titleLable.text = model.title;
    self.needCountLabel.text = [NSString stringWithFormat:@"招聘%@人", model.needcount];
    self.salaryLabel.text = model.salary;
    self.settletypeLabel.text = model.settletype;
    self.areaLabel.text = model.area;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
}

- (void)viewDidLoad{

    if ([self.delegate respondsToSelector:@selector(loadDataModelToView:)]) {
        [self.delegate loadDataModelToView:self];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 30;
    }
    return CGFLOAT_MIN;
}
@end

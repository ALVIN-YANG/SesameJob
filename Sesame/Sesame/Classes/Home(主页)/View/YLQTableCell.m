//
//  YLQTableCell.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/9.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQTableCell.h"
#import "YLQCellModel.h"
#import <UIImageView+WebCache.h>

@interface YLQTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *companyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleType;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTypeLabel;

@end
@implementation YLQTableCell

#pragma mark - 重写set加载数据
- (void)setCellModel:(YLQCellModel *)cellModel{
    _cellModel = cellModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.icon]];
    self.companyTitleLabel.text = cellModel.title;
    self.salaryLabel.text = [NSString stringWithFormat:@"%zd人浏览/%@", cellModel.pageview, cellModel.distance];
    self.priceLabel.text = [NSString stringWithFormat:@"%zd", cellModel.salary];
    self.priceTypeLabel.text = cellModel.settletype;
    self.circleType.text = cellModel.settlecircle;
    
}


@end

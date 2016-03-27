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

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *settlecircleLabel;
@property (weak, nonatomic) IBOutlet UILabel *getherTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *interviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *eatinfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostelinfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskinfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *resulthopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherrequireLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UILabel *duringTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UILabel *duringDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *corpnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *resumeCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *inHouseButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

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
    self.addressLabel.text = model.address;
    self.conditionLabel.text = model.condition;
    self.settlecircleLabel.text = model.settlecircle;
    self.getherTimeLabel.text = model.starttime;
    self.interviewLabel.text = model.interview;
    self.eatinfoLabel.text = model.eatinfo;
    self.hostelinfoLabel.text = model.hostelinfo;
    self.taskinfoLabel.text = model.taskinfo;
    self.resulthopeLabel.text = model.resulthope;
    self.trainLabel.text = model.train;
    self.otherrequireLabel.text = model.otherrequire;
    self.distanceLabel.text = model.distance;
    self.duringTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", model.starttime, model.endtime];
    if (model.mergeworkdays){
        self.duringDaysLabel.text = [NSString stringWithFormat:@"%@", model.mergeworkdays[0]];
    }else{
        self.duringDaysLabel.text = @"不限";
    }
    self.corpnameLabel.text = model.corpname;
    self.resumeCountLabel.text = [NSString stringWithFormat:@"已经招聘:%@人", model.resumucount];
    if (model.require) {
        self.requireLabel.text = model.require;
    }else{
        self.requireLabel.text = @"工作很轻松啊";
    }
}

- (void)viewDidLoad{

    if ([self.delegate respondsToSelector:@selector(loadDataModelToView:)]) {
        [self.delegate loadDataModelToView:self];
    }
    [self setThereButton];
}

- (void)setThereButton {
    [self.attentionButton.layer setMasksToBounds:YES];
    [self.attentionButton.layer setCornerRadius:7.0];
    [self.inHouseButton.layer setMasksToBounds:YES];
    [self.inHouseButton.layer setCornerRadius:10.0];
}

- (IBAction)attentionClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)inHouseButtonClick:(id)sender {
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

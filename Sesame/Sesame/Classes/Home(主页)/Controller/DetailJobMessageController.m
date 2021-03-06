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
#import <Masonry.h>
#import "DetailTableViewController.h"

@interface DetailJobMessageController ()<DetailTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, weak) DetailTableViewController *detailVC;
@end

@implementation DetailJobMessageController

#pragma mark - 重写数据set
- (void)setModel:(YLQDetailModel *)model {
    _model = model;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        DetailTableViewController *detailVC = [segue destinationViewController];
        detailVC.delegate = self;
    }
}

- (void)loadDataModelToView:(DetailTableViewController *)detailVC{
    self.detailVC = detailVC;
    detailVC.model = _model;
}

- (void)awakeFromNib{
    
//
//        _bottomView = bottomView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"职位详情";
    DetailTableViewController *detailVC = [[DetailTableViewController alloc] initWithNibName:NSStringFromClass([DetailTableViewController class]) bundle:nil];
    self.detailVC = detailVC;
    detailVC.model = self.model;
//    [self.containerView addSubview:detailVC.view];
}

- (IBAction)baomingClick:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://15653968657"]];
}



@end

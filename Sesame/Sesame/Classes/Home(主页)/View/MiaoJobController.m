//
//  MiaoJobController.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/27.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "MiaoJobController.h"

@interface MiaoJobController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MiaoJobController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"防骗指南";
    self.scrollView.contentInset = UIEdgeInsetsMake(- 64, 0, 0, 0);
    //    self.scrollView.contentOffset = CGPointMake(0, 64);
//    self.scrollView.contentSize = CGSizeMake(YLQScreenW, 1200);
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

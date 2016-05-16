//
//  YLQDetailPageViewViewController.m
//  集成高德LBS
//
//  Created by 杨卢青 on 16/4/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQDetailPageViewViewController.h"

@interface YLQDetailPageViewViewController ()

@end

@implementation YLQDetailPageViewViewController
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

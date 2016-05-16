//
//  LoginViewController.m
//  集成环信SDK2.0
//
//  Created by 杨卢青 on 16/3/31.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "LoginViewController.h"
#import "YLQTabBarController.h"
#import <EaseMob.h>
#import <SVProgressHUD.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loginClick:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.userName.text password:self.passWordLabel.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            
            NSLog(@"登录成功 %@", loginInfo);
            //设置自动登录状态
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            //进入主界面
            [UIApplication sharedApplication].keyWindow.rootViewController = [[YLQTabBarController alloc] init];
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }else {
            NSLog(@"登录失败%@", error);
        }
    } onQueue:nil];
}
- (IBAction)registerClick:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.userName.text password:self.passWordLabel.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            [SVProgressHUD showInfoWithStatus:@"注册成功\n点击登录"];
        }else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", error]];
        }
    } onQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

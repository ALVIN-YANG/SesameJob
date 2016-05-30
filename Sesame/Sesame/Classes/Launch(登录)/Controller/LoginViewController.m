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

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *owlImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (nonatomic, weak) UIImageView *imgLeftHand;
@property (nonatomic, weak) UIImageView *imgRightHand;
@property (nonatomic, weak) UIImageView *imgLeftHandGone;
@property (nonatomic, weak) UIImageView *imgRightHandGone;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;



@end
#define mainSize    [UIScreen mainScreen].bounds.size

#define offsetLeftHand      60

#define rectLeftHand        CGRectMake(61-offsetLeftHand, 90, 40, 65)
#define rectLeftHandGone    CGRectMake(mainSize.width / 2 - 100, _loginView.frame.origin.y - 25, 40, 40)

#define rectRightHand       CGRectMake(_owlImageView.frame.size.width / 2 + 60, 90, 40, 65)
#define rectRightHandGone   CGRectMake(mainSize.width / 2 + 62, _loginView.frame.origin.y - 25, 40, 40)
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initowlLogin];
}

- (void)initowlLogin
{
    _loginButton.layer.cornerRadius = 15;
    _registerButton.layer.cornerRadius = 15;
    _loginView.layer.borderWidth = 0.5;
    _loginView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView *imgH = [[UIImageView alloc]initWithFrame:rectLeftHand];
    _imgLeftHand = imgH;
    _imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [_owlImageView addSubview:_imgLeftHand];
    
    UIImageView *imgR = [[UIImageView alloc]initWithFrame:rectRightHand];
    _imgRightHand = imgR;
    _imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [_owlImageView addSubview:_imgRightHand];
    
    UIImageView *imLG = [[UIImageView alloc]initWithFrame:rectLeftHandGone];
    _imgLeftHandGone = imLG;
    _imgLeftHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:_imgLeftHandGone];
    
    UIImageView *imRG = [[UIImageView alloc]initWithFrame:rectRightHandGone];
    _imgRightHandGone = imRG;
    _imgRightHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:_imgRightHandGone];
    
    _userNameTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    _userNameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _userNameTextField.frame.size.height - 15, _userNameTextField.frame.size.height - 10)];
    UIImageView *leftV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-user"]];
    leftV.frame = CGRectMake(5, 0, _passwordTextField.bounds.size.height - 15, _passwordTextField.bounds.size.height - 15);
    [_userNameTextField.leftView addSubview:leftV];
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _passwordTextField.frame.size.height - 15, _passwordTextField.frame.size.height - 10)];
    UIImageView *rightV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-password"]];
    rightV.frame = CGRectMake(3, 0, _passwordTextField.bounds.size.height - 10, _passwordTextField.bounds.size.height - 10);
    [_passwordTextField.leftView addSubview:rightV];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
}


- (IBAction)loginClick:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_userNameTextField.text password:_passwordTextField.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            
            NSLog(@"登录成功 %@", loginInfo);
            //设置自动登录状态
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            [SVProgressHUD showInfoWithStatus:@"登陆成功!"];
            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
            
            
            [UIView animateWithDuration:1.7 animations:^{
                self.view.backgroundColor = [UIColor orangeColor];
                //进入主界面
                [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor orangeColor];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[YLQTabBarController alloc] init];
                [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
            }];
            
        }else {
            NSLog(@"登录失败%@", error);
        }
    } onQueue:nil];
}
- (IBAction)registerClick:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_userNameTextField.text password:_passwordTextField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            [SVProgressHUD showInfoWithStatus:@"注册成功\n点击登录"];
        }else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", error]];
        }
    } onQueue:nil];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.ylq_y = -50;
    if ([textField isEqual:_passwordTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _imgLeftHand.frame = CGRectMake(_imgLeftHand.frame.origin.x + offsetLeftHand, _imgLeftHand.frame.origin.y - 30, _imgLeftHand.frame.size.width, _imgLeftHand.frame.size.height);
            _imgRightHand.frame = CGRectMake(_imgRightHand.frame.origin.x - 48, _imgRightHand.frame.origin.y - 30, _imgRightHand.frame.size.width, _imgRightHand.frame.size.height);
            
            
            _imgLeftHandGone.frame = CGRectMake(_imgLeftHandGone.frame.origin.x + 70, _imgLeftHandGone.frame.origin.y, 0, 0);
            
            _imgRightHandGone.frame = CGRectMake(_imgRightHandGone.frame.origin.x - 30, _imgRightHandGone.frame.origin.y, 0, 0);
            
        } completion:^(BOOL b) {
        }];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.ylq_y = 0;
    if ([textField isEqual:_passwordTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            _imgLeftHand.frame = CGRectMake(_imgLeftHand.frame.origin.x - offsetLeftHand, _imgLeftHand.frame.origin.y + 30, _imgLeftHand.frame.size.width, _imgLeftHand.frame.size.height);
            
            _imgRightHand.frame = CGRectMake(_imgRightHand.frame.origin.x + 48, _imgRightHand.frame.origin.y + 30, _imgRightHand.frame.size.width, _imgRightHand.frame.size.height);
            
            
            _imgLeftHandGone.frame = CGRectMake(_imgLeftHandGone.frame.origin.x - 70, _imgLeftHandGone.frame.origin.y, 40, 40);
            
            _imgRightHandGone.frame = CGRectMake(_imgRightHandGone.frame.origin.x + 30, _imgRightHandGone.frame.origin.y, 40, 40);
            
            
        } completion:^(BOOL b) {
        }];
    }
}

@end

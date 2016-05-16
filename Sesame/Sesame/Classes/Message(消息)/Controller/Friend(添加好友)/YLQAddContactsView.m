//
//  YLQAddContactsView.m
//  集成环信SDK2.0
//
//  Created by 杨卢青 on 16/3/31.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQAddContactsView.h"
#import <EaseMob.h>
#import <SVProgressHUD.h>

@interface YLQAddContactsView()
@property (weak, nonatomic) IBOutlet UITextField *addTextField;

@end
@implementation YLQAddContactsView

- (void)viewDidLoad {
    
}

- (IBAction)addButtonClick:(id)sender {
    EMError *error = nil;
    //用户输入
    NSString *userName = self.addTextField.text;
    //发送请求给服务器
    [[EaseMob sharedInstance].chatManager addBuddy:userName message:@"泥嚎" error:&error];
    if (!error) {
//        NSLog(@"好友请求已经发送");
        [SVProgressHUD showInfoWithStatus:@"请求已经发送"];
    } else {
//        NSLog(@"好友请求失败");
        [SVProgressHUD showInfoWithStatus:@"请求失败"];
    }
}



@end

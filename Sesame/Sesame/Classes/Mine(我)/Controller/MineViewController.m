//
//  MineViewController.m
//  Sesame
//
//  Created by 杨卢青 on 16/1/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "MineViewController.h"
#import "FileCacheManager.h"
#import <SVProgressHUD.h>

@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (nonatomic, assign) NSInteger totalSize;

@end

@implementation MineViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"用户中心";
    //获取当前登录用户名称
    NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    self.userNameLabel.text = loginInfo[@"username"];
}

- (void)viewWillAppear:(BOOL)animated {
    [SVProgressHUD showWithStatus:@"正在计算缓存..."];
    // 获取cache文件夹路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    

    // 获取缓存尺寸
    [FileCacheManager getCacheSizeOfDirectoriesPath:cachePath completeBlock:^(NSInteger totalSize) {
        
        _totalSize = totalSize;
        NSLog(@"appear计算了缓存");
        self.cacheLabel.text = [self cacheStr:_totalSize];
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)logoutClick:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
            //回到登录界面
            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            self.view.window.rootViewController = SB.instantiateInitialViewController;
        } else {
            NSLog(@"退出失败 %@", error);
        }
    } onQueue:nil];

}


#pragma mark - 获取缓存字符串
// 获取缓存字符串
- (NSString *)cacheStr:(NSInteger)totalSize{
    // 获取文件夹缓存尺寸:文件夹比较小,文件夹非常大,获取尺寸比较耗时
    CGFloat cacheSizeF = 0;
    NSString *cacheStr = @"清空缓存";
    if (totalSize > (1000 * 1000)) { //MB
        cacheSizeF = totalSize / (1000 * 1000);
        cacheStr = [NSString stringWithFormat:@"清空缓存(%.1fMB)",cacheSizeF];
        cacheStr = [cacheStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (totalSize > 1000) { //KB
        cacheSizeF = totalSize / 1000;
        cacheStr = [NSString stringWithFormat:@"清空缓存(%.1fKB)",cacheSizeF];
    } else if (totalSize > 0){ // B
        cacheStr = [NSString stringWithFormat:@"清空缓存(%ldB)",totalSize];
    }
    
    return cacheStr;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section && 2 == indexPath.row) {
        // 删除cache缓存
        // 获取cache文件夹路径
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        
        // 真正清空缓存
        [FileCacheManager removeDirectoriesPath:cachePath];
        
        NSLog(@"清除了缓存");
        // 清空数据
        _totalSize = 0;
        
        [self.tableView reloadData];
        self.cacheLabel.text = [self cacheStr:_totalSize];
    }
}

@end


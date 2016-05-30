//
//  YLQRefreshHeader.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/9.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQRefreshHeader.h"

@interface YLQRefreshHeader()

@property (nonatomic, weak) UIImageView *logoView;

@end
@implementation YLQRefreshHeader
/**
 *  初始化
 */
- (void)prepare
{
    [super prepare];
    
    //自动切换透明度
    self.automaticallyChangeAlpha = YES;
    //隐藏时间
    //    self.lastUpdatedTimeLabel.hidden = YES;
    //修改状态文字的颜色
    //    self.stateLabel.textColor = [UIColor cyanColor];
    //修改状态文字
    //    [self setTitle:@"再次下拉" forState:MJRefreshStateIdle];//普通限制状态
        [self setTitle:@"放开我o(╯□╰)o" forState:MJRefreshStatePulling];
        [self setTitle:@"我在加载啊~>_<~ " forState:MJRefreshStateRefreshing];
    //添加logo
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_interesting"]];
    [self addSubview:logoView];
    self.logoView = logoView;
}

/**
 *  摆放子控件, 把logo放在上面
 */
- (void)placeSubviews{
    [super placeSubviews];
    self.logoView.ylq_center_X = self.ylq_width * 0.5;
    self.logoView.ylq_y = - self.logoView.ylq_height;
}
@end

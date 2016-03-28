//
//  YLQTitleButton.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQTitleButton.h"

@implementation YLQTitleButton

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

//取消高亮
- (void)setHighlighted:(BOOL)highlighted{}

@end

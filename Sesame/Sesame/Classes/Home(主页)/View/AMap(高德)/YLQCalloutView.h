//
//  YLQCalloutView.h
//  集成高德LBS
//
//  Created by 杨卢青 on 16/4/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLQCalloutView;
@protocol YLQCalloutViewDelegate <NSObject>
@required
- (void)jumpToDetailPage;

@end

@interface YLQCalloutView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, weak) id<YLQCalloutViewDelegate> delegate;
@end

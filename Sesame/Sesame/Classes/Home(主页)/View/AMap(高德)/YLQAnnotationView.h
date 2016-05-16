//
//  YLQAnnotationView.h
//  集成高德LBS
//
//  Created by 杨卢青 on 16/4/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "YLQCalloutView.h"

@interface YLQAnnotationView : MAAnnotationView

@property (nonatomic, readonly) YLQCalloutView *customCalloutView;
@end

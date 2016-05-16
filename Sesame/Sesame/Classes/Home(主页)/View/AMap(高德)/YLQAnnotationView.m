//
//  YLQAnnotationView.m
//  集成高德LBS
//
//  Created by 杨卢青 on 16/4/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQAnnotationView.h"


@interface YLQAnnotationView()
@property (nonatomic, strong, readwrite) YLQCalloutView *customCalloutView;
@end

#define lCalloutWidth   280.0
#define lCalloutHeight  70.0
@implementation YLQAnnotationView

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected == self.selected) {
        return;
    }
    
    if (selected) {
        if (nil == self.customCalloutView)
        {
            self.customCalloutView = [[YLQCalloutView alloc] initWithFrame:CGRectMake(0, 0, lCalloutWidth, lCalloutHeight)];
            self.customCalloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.customCalloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        self.customCalloutView.image = [UIImage imageNamed:@"building"];
        self.customCalloutView.title = self.annotation.title;
        self.customCalloutView.subtitle = self.annotation.subtitle;
        [self addSubview:self.customCalloutView];
    }
    else    //非选中状态, 删除calloutView
    {
        [self.customCalloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:YES];
}

// 重写此函数，用以实现点击calloutView判断为点击该annotationView
//:自定义的气泡是添加到大头针上的,  iOS 按钮超过父视图范围是无法响应事件的处理方法
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    
    if (!inside && self.selected)
    {
        inside = [self.customCalloutView pointInside:[self convertPoint:point toView:self.customCalloutView] withEvent:event];
    }
    
    return inside;
}



//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    
//        CGPoint tempoint = [self.calloutView convertPoint:point fromView:self];
//        if (CGRectContainsPoint(self.calloutView.bounds, tempoint))
//        {
//            view = self.calloutView;
//        }
//    
//    return view;
//}

@end

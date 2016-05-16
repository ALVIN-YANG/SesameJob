//
//  YLQCalloutView.m
//  集成高德LBS
//
//  Created by 杨卢青 on 16/4/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQCalloutView.h"
#import <QuartzCore/QuartzCore.h>
#import "YLQDetailPageViewViewController.h"

#define lArrorHeight    10

#define lPortraitMargin  5
#define lPortraitWidth  70
#define lPortraitHeight 50

#define lTitleWidth     200
#define lTitleHeight    20

@interface YLQCalloutView()

@property (nonatomic, strong) UIImageView * portraitView;
@property (nonatomic, strong) UILabel     * subtitleLabel;
@property (nonatomic, strong) UILabel     * titleLabel;
@property (nonatomic, strong) UIButton    * detailButton;

@end

@implementation YLQCalloutView
#pragma mark - over write
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)setImage:(UIImage *)image
{
    self.portraitView.image = image;
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DelegateJumpToDetailPage)];
        [self addGestureRecognizer:tapGesturRecognizer];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    //添加图片
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(lPortraitMargin, lPortraitMargin, lPortraitWidth, lPortraitHeight)];
    
    self.portraitView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.portraitView];
    
    //添加标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lPortraitMargin * 2 + lPortraitWidth, lPortraitMargin, lTitleWidth, lTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"title";
    [self addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lPortraitMargin * 2 + lPortraitWidth, lPortraitMargin - 5 + lTitleHeight, lTitleWidth, 40)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.text = @"subtitleLabelsubtitleLabelsubtitleLabel";
    [self addSubview:self.subtitleLabel];
    
    //添加按钮
    self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
}

#pragma mark - draw rect
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);

}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-lArrorHeight;
    
    CGContextMoveToPoint(context, midx+lArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+lArrorHeight);
    CGContextAddLineToPoint(context,midx-lArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)DelegateJumpToDetailPage
{
    if ([self.delegate respondsToSelector:@selector(jumpToDetailPage)]) {
        [self.delegate jumpToDetailPage];
    }
}
@end

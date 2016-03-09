//
//  YLQScrollPage.h
//  ScrollAdvertisementPage
//
//  Created by 杨卢青 on 16/2/23.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLQScrollPage;

@protocol  YLQScrollPageDelegate <NSObject>
@optional
- (void)infiniteScrollView:(YLQScrollPage *)scrollView didSelectItemAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, YLQInfiniteScrollViewDirection) {
    /** 水平滚动（左右滚动） */
    YLQInfiniteScrollViewDirectionHorizontal = 0,
    /** 垂直滚动（上下滚动） */
    YLQInfiniteScrollViewDirectionVertical
};

@interface YLQScrollPage : UIView
/** 图片数据(里面存放UIImage对象) */
@property (nonatomic, strong) NSArray *images;
/** 图片数据*/
//@property (nonatomic, strong) NSArray *imageUrls;
/** 滚动方向 */
@property (nonatomic, assign) YLQInfiniteScrollViewDirection direction;
/**延迟滚动时间*/
@property (nonatomic, assign) NSTimeInterval delayTime;
/** 代理 */
@property (nonatomic, weak) id<YLQScrollPageDelegate> delegate;

@property (nonatomic, weak, readonly) UIPageControl *pageControl;
@end

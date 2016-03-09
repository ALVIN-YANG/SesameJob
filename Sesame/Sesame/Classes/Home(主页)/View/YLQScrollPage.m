
//
//  YLQScrollPage.m
//  ScrollAdvertisementPage
//
//  Created by 杨卢青 on 16/2/23.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQScrollPage.h"
#import <objc/runtime.h>

@interface YLQScrollPage()<UIScrollViewDelegate>
/** 页码显示 */
@property (nonatomic, weak) UIPageControl *pageControl;
/** 显示具体内容 */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation YLQScrollPage

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        //scrollView的两个控件被隐藏了所以UIImageview可以用SUbView[i]
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        //取消边缘弹簧效果
        scrollView.bounces = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //添加3个UIImageView
        for (NSInteger i = 0;i < 3;i++){
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
            [scrollView addSubview:imageView];
        }
        UIPageControl *pageControll = [[UIPageControl alloc] init];
        [pageControll setValue:[UIImage imageNamed:@""] forKeyPath:@"_pageImage"];
        [pageControll setValue:[UIImage imageNamed:@""] forKeyPath:@"_currentPageImage"];
        [self addSubview:pageControll];
        self.pageControl = pageControll;
        
        
        //开启定时器
        [NSThread sleepForTimeInterval:self.delayTime];
//        [self performSelector:@selector(startTimer) withObject:nil afterDelay:self.delayTime];
        [self startTimer];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //整体尺寸
    CGFloat scrollViewW = self.bounds.size.width;
    CGFloat scrollViewH = self.bounds.size.height;
    
    //scrollView
    self.scrollView.frame = self.bounds;
    if (self.direction == YLQInfiniteScrollViewDirectionHorizontal) {
        self.scrollView.contentSize = CGSizeMake(3 * scrollViewW, 0);
    }else{
        self.scrollView.contentSize = CGSizeMake(0, 3 * scrollViewH);
    }
    //UIImageView
    for (NSInteger i = 0; i < 3;i++){
        UIImageView *imageView = self.scrollView.subviews[i];
        if (self.direction == YLQInfiniteScrollViewDirectionHorizontal) {
            imageView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
        }else{
            imageView.frame = CGRectMake(0, i * scrollViewH, scrollViewW, scrollViewH);
        }
    }
    //pageControll
    CGFloat pageControllW = 150;
    CGFloat pageControllH = 25;
    self.pageControl.frame = CGRectMake(scrollViewW - pageControllW, scrollViewH - pageControllH, pageControllW, pageControllH);
    
    //更新内容
    [self updateContent];
    
    //打印系统方法  UIPageControl 的属性
//    unsigned int outCount = 0;
//    Ivar *ivars = class_copyIvarList([UIPageControl class], &outCount);
//    for (NSInteger i = 0; i < outCount; i++) {
//        NSLog(@"%s", ivar_getName(ivars[i]));
//    }
//    free(ivars);
    //设置PageControl的图片
//    UIPageControl *pageControl = [[UIPageControl alloc] init];
//    [self addSubview:pageControl];
//    self.pageControl = pageControl;
//    
//    [pageControl setValue:[UIImage imageNamed:@"other"] forKeyPath:@"_pageImage"];
//    [pageControl setValue:[UIImage imageNamed:@"current"] forKeyPath:@"_currentPageImage"];
}

- (void)setImages:(NSArray *)images{
    _images = images;
    
    //总页数
    self.pageControl.numberOfPages = images.count;
}

#pragma mark - 监听点击
- (void)imageClick:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectItemAtIndex:)]) {
        [self.delegate infiniteScrollView:self didSelectItemAtIndex:tap.view.tag];
    }
}

#pragma mark - Method
- (void)updateContent{
    //当前页码
    NSInteger page = self.pageControl.currentPage;
    
    //更新所有UIImageView的内容   根据index决定是3个image的哪一个
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        //图片索引  布局图片index
        NSInteger index = 0;
        if (i == 0) {   //左边的imageView
            index = page - 1;
        }else if(i == 1){
            index = page;
        }else{
            index = page + 1;
        }
        
        //特殊情况  头尾
        if (index == -1){   //currentPage为0时左滑到最后一张
            index = self.images.count - 1;
        }else if (index == self.images.count){
            index = 0;
        }
        
        //添加图片
        imageView.image = self.images[index];
        //设置index为tag
        imageView.tag = index;
    }
    
    //重置scrollView.contentOffset.x == 1倍宽度,相当于滑完后ScrollView又正回来了, 只是改变了三个Imageview的图片
    if (self.direction == YLQInfiniteScrollViewDirectionHorizontal){
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }else{
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
}

#pragma mark - 定时器
- (void)startTimer{
    //赋值定时器,加入主循环
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage{
    if (self.direction == YLQInfiniteScrollViewDirectionHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + self.scrollView.frame.size.height) animated:YES];
    }
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  只要scrollView滚动, 就会调用这个方法, 改变图片索引
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //求出最中间的imageView, 就会调用这个方法
    UIImageView *destImageView = nil;
    CGFloat minDelta = MAXFLOAT;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        CGFloat delta = 0;
        if (self.direction == YLQInfiniteScrollViewDirectionHorizontal) {
            delta = ABS(self.scrollView.contentOffset.x - imageView.frame.origin.x);
        }else{
            delta = ABS(self.scrollView.contentOffset.y - imageView.frame.origin.y);
        }
        if (delta < minDelta) {
            minDelta = delta;
            destImageView = imageView;
        }
    }
    //imageView的tag就是显示在最中间的图片索引
    self.pageControl.currentPage = destImageView.tag;
}
/**
 *  当ScrollView停止滚动时调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateContent];
    [self startTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}
//setContentOffset   Animation  的动画结束后会调用此方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self updateContent];
}
@end

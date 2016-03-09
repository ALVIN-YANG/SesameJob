//
//  NSDate+Interval.h
//  01-BS搭建
//
//  Created by 杨卢青 on 16/2/14.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  返回时间间隔的  多种方法 (最后选用模型)
 */

/**
 *  模型
 */
@interface YLQInterval : NSObject
/**天*/
@property (nonatomic, assign) NSInteger ylq_day NS_AVAILABLE_IOS(6_0);
@property (nonatomic, assign) NSInteger  day NS_DEPRECATED_IOS(2_0, 7_0, "USE ylq_day");
/**小时*/
@property (nonatomic, assign) NSInteger ylq_hour;
/**分钟*/
@property (nonatomic, assign) NSInteger ylq_minute;
/**秒*/
@property (nonatomic, assign) NSInteger ylq_second;
@end

@interface NSDate (Interval)
/**
 *  字典
 */

/**
 *  枚举
 */
typedef enum{
    XMGIntervalIndexDay = 0,
    XMGIntervalIndexHour = 1,
    XMGIntervalIndexMinute = 2,
    XMGIntervalIndexSecond = 3,
} YLQIntervalIndex;

/**
 *  结构体
 */
typedef struct {
    NSInteger day;
    NSInteger Hour;
    NSInteger Minute;
    NSInteger Second;
} YLQ_Interval;


/**
 *  返回模型方法
 */
- (YLQInterval *)ylq_intervalSinceDate:(NSDate *)date;
/**
 *  是否是今天
 */
- (BOOL)ylq_isInToday;
/**
 *  是否是昨天
 */
- (BOOL)ylq_isInYesterday;
/**
 *  是否为明天
 */
- (BOOL)ylq_isTomorrow;
/**
 *  是否为今年
 */
- (BOOL)ylq_isInInThisYear;

@end

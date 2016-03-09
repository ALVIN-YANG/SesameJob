//
//  NSDate+Interval.m
//  01-BS搭建
//
//  Created by 杨卢青 on 16/2/14.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "NSDate+Interval.h"
#import "NSCalendar+Init.h"

/**
 *  模型也要有实现
 */
@implementation YLQInterval

@end
@implementation NSDate (Interval)
- (YLQInterval *)ylq_intervalSinceDate:(NSDate *)date{
    //从date到现在走过的秒数
    NSInteger interval = [self timeIntervalSinceDate:date];
    
    NSInteger secondsPerMinute = 60;
    NSInteger secondsPerHour = 3600;
    NSInteger secondsPerDay = secondsPerHour * 24;
    
    YLQInterval *intervalItem = [[YLQInterval alloc] init];
    intervalItem.ylq_day = interval / secondsPerDay;
    intervalItem.ylq_hour = (interval % secondsPerDay) / secondsPerHour;
    intervalItem.ylq_minute = (interval % secondsPerHour) /secondsPerMinute;
    intervalItem.ylq_second = interval % secondsPerMinute;
    return intervalItem;
}

-(BOOL)ylq_isInToday{
    NSCalendar *calendar = [NSCalendar ylq_calentar];
    
    //获得年月日
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    //self  调用此方法的对象
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    //现在
    NSDateComponents *dateCmps = [calendar components:unit fromDate:[NSDate date]];
    
    return [selfCmps isEqual:dateCmps];
}
- (BOOL)ylq_isInInThisYear{
    NSCalendar *calendar = [NSCalendar ylq_calentar];
    
    //获取年
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    NSDateComponents *dateCmps = [calendar components:unit fromDate:[NSDate date]];
    return [selfCmps isEqual:dateCmps];
}

//是否是昨天
- (BOOL)ylq_isInYesterday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    //获取只有年月日的字符串
    NSString *selfString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    //再转成date
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    //比较
    NSCalendar *calendar = [NSCalendar ylq_calentar];
    //获取Date的差值  若指定天, 则自动计算年月
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}
//是否是明天
- (BOOL)ylq_isTomorrow{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    //获取只有年月日的字符串
    NSString *selfString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    //转换成Date
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    //计算差
    NSCalendar *calendar = [NSCalendar ylq_calentar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == -1;
}


@end

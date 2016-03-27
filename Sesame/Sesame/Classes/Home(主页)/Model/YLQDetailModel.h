//
//  YLQDetailModel.h
//  Sesame
//
//  Created by 杨卢青 on 16/3/25.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLQDetailModel : NSObject
/**title*/
@property (nonatomic, copy) NSString *title;
/**icon*/
@property (nonatomic, copy) NSString *icon;
/**resumucount*/
@property (nonatomic, copy) NSString *resumucount;
/**needCount*/
@property (nonatomic, copy) NSString *needcount;
/**needcount*/
@property (nonatomic, copy) NSString *salary;
/**area*/
@property (nonatomic, copy) NSString *area;
/**settletype*/
@property (nonatomic, copy) NSString *settletype;

/**距离*/
@property (nonatomic, copy) NSString *distance;
/**日结*/
@property (nonatomic, copy) NSString *settlecircle;
/**工作地点*/
@property (nonatomic, copy) NSString *address;
/**性别*/
@property (nonatomic, copy) NSString *condition;
/**工作日期*/
@property (nonatomic, copy) NSArray *mergeworkdays;
/**工作时间  start  , end*/
@property (nonatomic, copy) NSString *endtime;
/**集合时间*/
@property (nonatomic, copy) NSString *starttime;
/**集合地点*/
@property (nonatomic, copy) NSString *gatherplace;
/**工作内容*/
@property (nonatomic, copy) NSString *require;
/**面试详情*/
@property (nonatomic, copy) NSString *interview;
/**是否管饭*/
@property (nonatomic, copy) NSString *eatinfo;
/**是否管住*/
@property (nonatomic, copy) NSString *hostelinfo;
/**底薪任务*/
@property (nonatomic, copy) NSString *taskinfo;
/**绩效提成*/
@property (nonatomic, copy) NSString *resulthope;
/**培训详情*/
@property (nonatomic, copy) NSString *train;
/**其他事项*/
@property (nonatomic, copy) NSString *otherrequire;
/**公司*/
@property (nonatomic, copy) NSString *corpname;
@end

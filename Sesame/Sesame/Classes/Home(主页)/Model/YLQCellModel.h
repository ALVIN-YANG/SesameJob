//
//  YLQCellModel.h
//  Sesame
//
//  Created by 杨卢青 on 16/3/9.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLQCellModel : NSObject



/**begindate*/
@property (nonatomic, assign) long begindate;
/**enddate*/
@property (nonatomic, assign) long enddate;
/**distance*/
@property (nonatomic, copy) NSString *distance;
/**icon*/
@property (nonatomic, copy) NSString *icon;
/**jobtype*/
@property (nonatomic, copy) NSString *jobtype;
/**pageview*/
@property (nonatomic, assign) NSInteger pageview;
/**salary*/
@property (nonatomic, assign) NSInteger salary;
/**日结*/
@property (nonatomic, copy) NSString *settlecircle;
/**settletype*/
@property (nonatomic, copy) NSString *settletype;
/**title*/
@property (nonatomic, copy) NSString *title;

@end

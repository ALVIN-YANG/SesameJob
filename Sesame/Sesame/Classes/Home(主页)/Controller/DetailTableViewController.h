//
//  DetailTableViewController.h
//  Sesame
//
//  Created by 杨卢青 on 16/3/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLQDetailModel, DetailTableViewController;
@protocol  DetailTableViewDelegate <NSObject>
- (void)loadDataModelToView:(DetailTableViewController *)detailVC;
@end
@interface DetailTableViewController : UITableViewController
/**data*/
@property (nonatomic, strong) YLQDetailModel *model;

/**delegate*/
@property (nonatomic, weak) id<DetailTableViewDelegate> delegate;
@end

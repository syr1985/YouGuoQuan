//
//  PersonOrderListViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/4.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrderType) {
    OrderType_All = 0,
    OrderType_Waiting,
    OrderType_Ongoing,
    OrderType_Completed,
    OrderType_Refunding
};

@interface AllOrderListViewController : UIViewController

@property (nonatomic, assign) OrderType type;

@end

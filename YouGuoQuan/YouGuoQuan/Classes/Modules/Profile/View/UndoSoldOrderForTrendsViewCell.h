//
//  UndoSoldOrderForTrendsViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/19.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface UndoSoldOrderForTrendsViewCell : UITableViewCell
@property (nonatomic,   copy) void (^sendedProductBlock)(NSString *orderNo, BOOL type);
@property (nonatomic,   copy) void (^agreeWithRefundBlock)(NSString *orderNo);
@property (nonatomic, strong) MyOrderModel *orderModel;
@end
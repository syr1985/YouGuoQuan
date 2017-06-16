//
//  UndoSoldOrderForTrendsViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface DoneSoldOrderForWeiXinViewCell : UITableViewCell
@property (nonatomic,   copy) void (^deleteOrderBlock)(NSString *orderNo);
@property (nonatomic, strong) MyOrderModel *orderModel;
@end

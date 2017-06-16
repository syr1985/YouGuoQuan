//
//  EvaluationViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kNotification_RefreshTableView = @"OperateOrderSuccess";

@interface EvaluationViewController : UIViewController
@property (nonatomic,   copy) NSString *orderId;
@property (nonatomic,   copy) NSString *goodsId;
@property (nonatomic,   copy) NSString *goodsName;
@end

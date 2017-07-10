//
//  RewardViewController.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/2.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardViewController : UIViewController
@property (nonatomic,   copy) NSString *userID;
@property (nonatomic,   copy) NSString *rType; // 这个参数用于区分是打赏，还是发红包(消息里)，打赏的话=@“ds” ,红包=@“hb”
@property (nonatomic,   copy) void (^payForReward)(NSNumber *amount, NSString *payType, NSString *orderNo);
@end

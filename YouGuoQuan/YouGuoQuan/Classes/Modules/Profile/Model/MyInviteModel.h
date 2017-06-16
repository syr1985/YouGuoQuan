//
//  MyInviteModel.h
//  YouGuoQuan
//
//  Created by YM on 2017/6/14.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 {
 audit = 1;
 createTime = 1494928611000;
 headImg = "";
 mobile = 18951718976;
 myUserId = "6c8ed7c7-cef3-41ad-9de7-05f0ae623676";
 nickName = "\U6625\U513f";
 star = 3;
 totalMoney = 426;
 }
 */
@interface MyInviteModel : NSObject
@property (nonatomic,   copy) NSString *myUserId;
@property (nonatomic,   copy) NSString *nickName;
@property (nonatomic,   copy) NSString *headImg;
@property (nonatomic,   copy) NSString *mobile;
@property (nonatomic, strong) NSNumber *totalMoney;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, assign) int star;
@property (nonatomic, assign) int audit;

+ (instancetype)myInviteModelWithDict:(NSDictionary *)dict;
- (instancetype)initMyInviteModelWithDict:(NSDictionary *)dict;
@end

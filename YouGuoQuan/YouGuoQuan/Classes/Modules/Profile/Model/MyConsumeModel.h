//
//  MyIncomeModel.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/17.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 balance = "0.0";
 buyerBalance = "14933.4";
 buyerId = "fc5e3f69-a4e2-44fb-b48f-c8b5f2c5abe6";
 buyerNickName = buyername;
 createTime = 1493100487000;
 goodsId = goodsId;
 goodsName = "\U5f00\U901a\U4f1a\U5458";
 goodsPrice = "66.6";
 id = "202facf8-b2fe-47a6-8321-0fb895ee6ac3";
 isDelete = "";
 orderNo = NB143881493100473904;
 payMethod = wallet;
 sellerId = systemsellid;
 sellerNickName = systemsell;
 updateTime = 1493100487000;
 }
*/
@interface MyConsumeModel : NSObject
@property (nonatomic,   copy) NSString *incomeId;
@property (nonatomic,   copy) NSString *buyerId;
@property (nonatomic,   copy) NSString *buyerNickName;
@property (nonatomic,   copy) NSString *goodsId;
@property (nonatomic,   copy) NSString *goodsName;
@property (nonatomic,   copy) NSString *sellerId;
@property (nonatomic,   copy) NSString *sellerNickName;
@property (nonatomic,   copy) NSString *createTime;
@property (nonatomic,   copy) NSString *updateTime;
@property (nonatomic,   copy) NSString *orderNo;
@property (nonatomic,   copy) NSString *payMethod;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *buyerBalance;
@property (nonatomic, strong) NSString *goodsPrice;
@property (nonatomic, assign) BOOL isDelete;

+ (instancetype)myConsumeModelWithDict:(NSDictionary *)dict;
- (instancetype)initMyConsumeModelWithDict:(NSDictionary *)dict;
@end

//
//  MyOrderModel.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/12.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject
@property (nonatomic,   copy) NSString *orderId;
@property (nonatomic,   copy) NSString *buyUserHeadImg;
@property (nonatomic,   copy) NSString *buyUserId;
@property (nonatomic,   copy) NSString *buyUserNickName;
@property (nonatomic,   copy) NSString *buyerDesc;
@property (nonatomic,   copy) NSString *buyerEmail;
@property (nonatomic,   copy) NSString *buyerPhone;
@property (nonatomic,   copy) NSString *createTime;
@property (nonatomic,   copy) NSString *updateTime;
@property (nonatomic,   copy) NSString *feedsId;
@property (nonatomic,   copy) NSString *goodsId;
@property (nonatomic,   copy) NSString *goodsName;
@property (nonatomic,   copy) NSString *haveComment;
@property (nonatomic,   copy) NSString *headImg;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic,   copy) NSString *orderNo;
@property (nonatomic,   copy) NSString *payMethod;
@property (nonatomic,   copy) NSString *saleNickName;
@property (nonatomic,   copy) NSString *saleUserId;
@property (nonatomic,   copy) NSString *servOrGoods;
@property (nonatomic,   copy) NSString *dateAddress;
@property (nonatomic,   copy) NSString *dateTimeInfo;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, assign) int  goodsDetailType; // 1待付款 2购买进行中 3退款进行中 4购买成功 5 退款成功 6 交易关闭
@property (nonatomic, assign) int  orderType;   // 1 = 退款中，2 = 拒绝服务，3 = 正常，4 = 已发货
@property (nonatomic, assign) int  orderStatus; // 1 = 已完成，2 = 进行中 3 = 关闭
@property (nonatomic, assign) int  payStatus;   // 1 = 待支付，2 = 已支付
@property (nonatomic, assign) BOOL isReal;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, assign) BOOL isAutoShip;

+ (instancetype)myOrderModelWithDict:(NSDictionary *)dict;
- (instancetype)initMyOrderModelWithDict:(NSDictionary *)dict;
@end

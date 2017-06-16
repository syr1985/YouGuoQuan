//
//  LoginData.h
//  ShakeAround
//
//  Created by YM on 15/11/20.
//  Copyright © 2015年 erick. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 audit = 3;
 auditResult = "\U6a21\U7279,\U6f14\U5458,\U8f66\U6a21";
 havePublishWX = 0;
 headImg = "http://7xtk9y.com1.z0.glb.clouddn.com/QgLsUCBrLM08aNAF.jpg";
 hxp = b817926ef0886c43f6b362d9118a3cbc;
 hxu = nt13276665576;
 id = "fc5e3f69-a4e2-44fb-b48f-c8b5f2c5abe6";
 isRecommend = 1;
 msg = success;
 nickName = "\U4e0d\U77e5\U706b\U821e";
 ope = 1;
 requestseq = i3JUt;
 result = 000;
 star = 2;
 ymu = nt13276665576;
 zfb = 13276665576;
 zfbRealName = "\U5fb7\U56fd\U548c\U73af\U5883";
 */

@interface LoginData : NSObject
// 用户Id
@property (nonatomic,   copy) NSString *userId;
// 头像
@property (nonatomic,   copy) NSString *headImg;
// 用户昵称
@property (nonatomic,   copy) NSString *nickName;
// 认证的支付宝账号
@property (nonatomic,   copy) NSString *zfbAccount;
// 认证的实名
@property (nonatomic,   copy) NSString *realName;
// 认证结果
@property (nonatomic,   copy) NSString *auditResult;
// 环信密码
@property (nonatomic,   copy) NSString *hxp;
// 环信账号
@property (nonatomic,   copy) NSString *hxu;
// umeng推送绑定的别名，(赞用userID代替)
@property (nonatomic,   copy) NSString *ymu;
// 发布的微信号
@property (nonatomic,   copy) NSString *publishWX;
// 发布的微信价格
@property (nonatomic,   copy) NSString *publishWXPrice;
// 手机号
@property (nonatomic,   copy) NSString *phone;
// 是否认证 0 1 2
@property (nonatomic, assign) int  audit;
// 是否会员
@property (nonatomic, assign) BOOL isRecommend;
// 等级 1~6
@property (nonatomic, assign) int  star;
// 是否发布过微信
@property (nonatomic, assign) BOOL havePublishWX;
// 原来作为绕过审核用的，废弃
@property (nonatomic, assign) BOOL ope;

+ (instancetype)sharedLoginData;
+ (instancetype)loginDataWithDict:(NSDictionary *)dict;
- (instancetype)initLoginDataWithDict:(NSDictionary *)dict;

@end
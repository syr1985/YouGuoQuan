//
//  HomeFocusModel.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeFocusModel : NSObject
@property (nonatomic,   copy) NSString *focusId;
@property (nonatomic,   copy) NSString *goodsId;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic,   copy) NSString *goodsName;
@property (nonatomic,   copy) NSString *instro;
@property (nonatomic,   copy) NSString *userId;
@property (nonatomic,   copy) NSString *createTime;
@property (nonatomic,   copy) NSString *updateTime;
@property (nonatomic,   copy) NSString *videoEvelope;
@property (nonatomic,   copy) NSString *videoUrl;
@property (nonatomic,   copy) NSString *timeLineId;
@property (nonatomic,   copy) NSString *auditResult;
@property (nonatomic,   copy) NSString *sex;
@property (nonatomic,   copy) NSString *nickName;
@property (nonatomic,   copy) NSString *headImg;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSNumber *buyCount;
@property (nonatomic, strong) NSNumber *buyCommentGoodCount;
@property (nonatomic, strong) NSNumber *recommendCount;
@property (nonatomic, strong) NSNumber *playTimes;
// 等级数
@property (nonatomic, assign) int  star;
// 是否购买（红包、商品）
@property (nonatomic, assign) BOOL isBuy;
// 是否认证（vip）
@property (nonatomic, assign) int  audit;
// 是否贵族
@property (nonatomic, assign) BOOL isRecommend;
// 是否赞过
@property (nonatomic, assign) BOOL praise;
// 是否删除
@property (nonatomic, assign) BOOL isDelete;
// 动态类型 1、图文，2、视频，3、商品，4、红包
@property (nonatomic, assign) int  feedsType;
// Cell的高（自己根据数据计算的，不在返回字段里）
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)homeFocusModelWithDict:(NSDictionary *)dict;
- (instancetype)initHomeFocusModelWithDict:(NSDictionary *)dict;
@end

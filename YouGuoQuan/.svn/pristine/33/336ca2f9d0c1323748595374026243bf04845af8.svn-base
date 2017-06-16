//
//  UserCenterModel.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/14.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterModel : NSObject
@property (nonatomic,   copy) NSString *trendsId;
@property (nonatomic,   copy) NSString *goodsId;
@property (nonatomic,   copy) NSString *userId;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic,   copy) NSString *goodsName;
@property (nonatomic,   copy) NSString *instro;
@property (nonatomic,   copy) NSString *videoEvelope;
@property (nonatomic,   copy) NSString *videoUrl;
@property (nonatomic,   copy) NSString *createTime;
@property (nonatomic,   copy) NSString *updateTime;
@property (nonatomic,   copy) NSString *dateString;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *recommendCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSNumber *buyCommentGoodCount;
@property (nonatomic, strong) NSNumber *buyCount;
@property (nonatomic, strong) NSNumber *playTimes;
@property (nonatomic, assign) BOOL isBuy;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, assign) BOOL praise;
@property (nonatomic, assign) int  feedsType;
// Cell的高（自己根据数据计算的，不在返回字段里）
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)userCenterModelWithDict:(NSDictionary *)dict;
- (instancetype)initUserCenterModelWithDict:(NSDictionary *)dict;
@end

//
//  DiscoveryCrowdfundingModel.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 bannerImageUrl = "http://7xtk9y.com1.z0.glb.clouddn.com/d380277c82f612601adfea209d51a99fcf968f0340e98304a46ea3b866d8cb6f..jpg;http://7xtk9y.com1.z0.glb.clouddn.com/29e6ec55480091b5ebbc757e5876f30a9082811da5a16d7bed6e8944ce707404..jpg";
 cOrganizer = ww;
 cTitle = "\U5b8cw";
 cfTimeEnd = "2017/01/20";
 coverImgUrl = "http://7xtk9y.com1.z0.glb.clouddn.com/fc5ea652270b805ae5db7a3d143f6d1ed650b55875a1fe091fb630c871372657..jpg";
 createTime = 1481093703000;
 descs = SfvcSVD;
 id = "378c380b-004e-4810-9056-51cd9dfc35dc";
 isDelete = "";
 joinPeople = 3;
 modle = "";
 prizeDescs = SVSV;
 timeEnd = "2017/01/07";
 timeStart = "2017/01/06";
 updateTime = 1480665475000;
 
 */
@interface DiscoveryCrowdfundingModel : NSObject
@property (nonatomic,   copy) NSString *crowdfundingId;
@property (nonatomic,   copy) NSString *createTime;
@property (nonatomic,   copy) NSString *updateTime;
// 详情图
@property (nonatomic,   copy) NSString *bannerImageUrl;
// 封面图
@property (nonatomic,   copy) NSString *coverImgUrl;
// 标题
@property (nonatomic,   copy) NSString *cTitle;
// 众筹截止时间
@property (nonatomic,   copy) NSString *cfTimeEnd;
// 活动描述
@property (nonatomic,   copy) NSString *descs;
// 奖项
@property (nonatomic,   copy) NSString *prizeDescs;
// 活动开始时间
@property (nonatomic,   copy) NSString *timeStart;
// 活动结束时间
@property (nonatomic,   copy) NSString *timeEnd;
// 主办范围
@property (nonatomic,   copy) NSString *cOrganizer;
// 模特
@property (nonatomic,   copy) NSString *modle;
//
@property (nonatomic, assign) BOOL isDelete;
// 目前参加总人数
@property (nonatomic, assign) NSUInteger joinPeople;

+ (instancetype)discoveryCrowdfundingModelWithDict:(NSDictionary *)dict;
- (instancetype)initDiscoveryCrowdfundingModelWithDict:(NSDictionary *)dict;
@end

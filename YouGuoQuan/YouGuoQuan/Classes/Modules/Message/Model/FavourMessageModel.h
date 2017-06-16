//
//  FavourMessageModel.h
//  YouGuoQuan
//
//  Created by YM on 2017/2/24.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavourMessageModel : NSObject
@property (nonatomic,   copy) NSString *relationId;
@property (nonatomic,   copy) NSString *userId;
@property (nonatomic,   copy) NSString *nickName;
@property (nonatomic,   copy) NSString *headImg;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic,   copy) NSString *createtime;
@property (nonatomic, assign) int  type;
@property (nonatomic, assign) int  audit;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) int  star;

+ (instancetype)favourMessageModelWithDict:(NSDictionary *)dict;
- (instancetype)initFavourMessageModelWithDict:(NSDictionary *)dict;
@end
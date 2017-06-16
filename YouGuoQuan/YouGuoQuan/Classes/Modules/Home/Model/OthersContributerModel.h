//
//  OthersContributerModel.h
//  YouGuoQuan
//
//  Created by YM on 2017/2/22.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OthersContributerModel : NSObject
@property (nonatomic,   copy) NSString *headImg;
@property (nonatomic,   copy) NSString *nickName;
@property (nonatomic,   copy) NSString *userId;
@property (nonatomic,   copy) NSString *rankTime;
@property (nonatomic,   copy) NSString *rank;
@property (nonatomic,   copy) NSString *totalMoney;
@property (nonatomic,   copy) NSString *sex;
@property (nonatomic, assign) int star;
@property (nonatomic, assign) int audit;
@property (nonatomic, assign) BOOL isRecommend;

+ (instancetype)othersContributerModelWithDict:(NSDictionary *)dict;
- (instancetype)initOthersContributerModelWithDict:(NSDictionary *)dict;
@end

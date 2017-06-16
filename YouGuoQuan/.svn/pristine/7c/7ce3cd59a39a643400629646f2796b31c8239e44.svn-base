//
//  NearbyUserModel.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "NearbyUserModel.h"
#import <MJExtension.h>

@implementation NearbyUserModel

+ (instancetype)nearbyUserModelWithDict:(NSDictionary *)dict {
    [NearbyUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id"};
    }];
    return [[NearbyUserModel alloc] initNearbyUserModelWithDict:dict];
}

- (instancetype)initNearbyUserModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [NearbyUserModel mj_objectWithKeyValues:dict];
    }
    return self;
}

@end

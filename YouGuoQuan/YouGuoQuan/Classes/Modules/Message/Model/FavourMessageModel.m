//
//  FavourMessageModel.m
//  YouGuoQuan
//
//  Created by YM on 2017/2/24.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "FavourMessageModel.h"
#import <MJExtension.h>

@implementation FavourMessageModel

+ (instancetype)favourMessageModelWithDict:(NSDictionary *)dict {
    return [[FavourMessageModel alloc] initFavourMessageModelWithDict:dict];
}

- (instancetype)initFavourMessageModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [FavourMessageModel mj_objectWithKeyValues:dict];
    }
    return self;
}

@end
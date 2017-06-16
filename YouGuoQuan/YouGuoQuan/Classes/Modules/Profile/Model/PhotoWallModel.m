//
//  PhotoWallModel.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/30.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "PhotoWallModel.h"
#import <MJExtension.h>

@implementation PhotoWallModel

+ (instancetype)photoWallModelWithDict:(NSDictionary *)dict {
    [PhotoWallModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"imageId" : @"id"};
    }];
    return [[PhotoWallModel alloc] initPhotoWallModelWithDict:dict];
}

- (instancetype)initPhotoWallModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [PhotoWallModel mj_objectWithKeyValues:dict];
    }
    return self;
}
@end

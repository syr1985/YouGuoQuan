//
//  DiscoveryVideoModel.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "DiscoveryVideoModel.h"
#import <MJExtension.h>
#import "NSString+StringSize.h"

@implementation DiscoveryVideoModel

+ (instancetype)discoveryVideoModelWithDict:(NSDictionary *)dict {
    [DiscoveryVideoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"videoId" : @"id"};
    }];
    return [[DiscoveryVideoModel alloc] initDiscoveryVideoModelWithDict:dict];
}

- (instancetype)initDiscoveryVideoModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [DiscoveryVideoModel mj_objectWithKeyValues:dict];
    }
    return self;
}

- (int)star {
    if (_star > 6) {
        return 6;
    }
    return _star;
}

@end

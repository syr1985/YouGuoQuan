//
//  HomeResourceModel.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/3.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "HomeResourceModel.h"
#import <MJExtension/MJExtension.h>

@implementation HomeResourceModel

+ (instancetype)homeResourceModelWithDict:(NSDictionary *)dict {
    [HomeResourceModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id"};
    }];
    return [[HomeResourceModel alloc] initHomeResourceModelWithDict:dict];
}

- (instancetype)initHomeResourceModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self =  [HomeResourceModel mj_objectWithKeyValues:dict];
    }
    return self;
}

- (int)star {
    if (_star > 6) {
        return 6;
    }
    return _star;
}

- (NSNumber *)imageCount {
    if (!_imageCount) {
        return @0;
    }
    return _imageCount;
}

@end

//
//  MyInviteModel.m
//  YouGuoQuan
//
//  Created by YM on 2017/6/14.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MyInviteModel.h"
#import <MJExtension.h>

@implementation MyInviteModel

+ (instancetype)myInviteModelWithDict:(NSDictionary *)dict {
    return [[MyInviteModel alloc] initMyInviteModelWithDict:dict];
}

- (instancetype)initMyInviteModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [MyInviteModel mj_objectWithKeyValues:dict];
    }
    return self;
}

@end

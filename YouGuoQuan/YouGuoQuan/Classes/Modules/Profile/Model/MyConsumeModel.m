//
//  MyIncomeModel.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/17.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MyConsumeModel.h"
#import <MJExtension.h>

@implementation MyConsumeModel

+ (instancetype)myConsumeModelWithDict:(NSDictionary *)dict {
    [MyConsumeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"incomeId" : @"id"};
    }];
    return [[MyConsumeModel alloc] initMyConsumeModelWithDict:dict];
}

- (instancetype)initMyConsumeModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [MyConsumeModel mj_objectWithKeyValues:dict];
    }
    return self;
}

@end

//
//  MyOrderModel.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/12.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MyOrderModel.h"
#import <MJExtension.h>

@implementation MyOrderModel

+ (instancetype)myOrderModelWithDict:(NSDictionary *)dict {
    [MyOrderModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"orderId" : @"id"};
    }];
    return [[MyOrderModel alloc] initMyOrderModelWithDict:dict];
}

- (instancetype)initMyOrderModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [MyOrderModel mj_objectWithKeyValues:dict];
    }
    return self;
}

- (NSNumber *)price {
    if (!_price) {
        return @0;
    }
    return _price;
}

@end

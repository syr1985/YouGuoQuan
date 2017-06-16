//
//  ProductDetailModel.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/20.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ProductDetailModel.h"
#import <MJExtension.h>
#import "NSString+StringSize.h"

@implementation ProductDetailModel

+ (instancetype)productDetailModelWithDict:(NSDictionary *)dict {
    [ProductDetailModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"goodsId" : @"id"};
    }];
    return [[ProductDetailModel alloc] initProductDetailModelWithDict:dict];
}

- (instancetype)initProductDetailModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [ProductDetailModel mj_objectWithKeyValues:dict];
        
        CGFloat titleH = [NSString heightWithString:self.goodsInstro
                                            maxSize:CGSizeMake(WIDTH - 24, 0)
                                            strFont:[UIFont systemFontOfSize:12]];
        self.cellHeight = WIDTH * 46 / 75 + titleH + 70;
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

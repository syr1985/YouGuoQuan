//
//  OthersContributerModel.m
//  YouGuoQuan
//
//  Created by YM on 2017/2/22.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "OthersContributerModel.h"
#import <MJExtension.h>

@implementation OthersContributerModel

+ (instancetype)othersContributerModelWithDict:(NSDictionary *)dict {
    return [[OthersContributerModel alloc] initOthersContributerModelWithDict:dict];
}

- (instancetype)initOthersContributerModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [OthersContributerModel mj_objectWithKeyValues:dict];
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

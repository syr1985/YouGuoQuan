//
//  UserBaseInfoModel.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/3.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "UserBaseInfoModel.h"
#import <MJExtension/MJExtension.h>

@implementation UserBaseInfoModel

+ (instancetype)userBaseInfoModelWithDict:(NSDictionary *)dict {
    [UserBaseInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id"};
    }];
    return [[UserBaseInfoModel alloc] initUserBaseInfoModelWithDict:dict];
}

- (instancetype)initUserBaseInfoModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self =  [UserBaseInfoModel mj_objectWithKeyValues:dict];
    }
    return self;
}

- (NSString *)constellatory {
    if (!_constellatory || !_constellatory.length) {
        return @"未填写";
    }
    return _constellatory;
}

- (NSString *)work {
    if (!_work || !_work.length) {
        return @"未填写";
    }
    return _work;
}

- (NSString *)weight {
    if (!_weight || !_weight.length) {
        return @"未填写";
    }
    return _weight;
}

- (NSString *)height {
    if (!_height || !_height.length) {
        return @"未填写";
    }
    return _height;
}

- (NSString *)emotion {
    if (!_emotion || !_emotion.length) {
        return @"未填写";
    }
    return _emotion;
}

- (NSString *)auditResult {
    if (!_auditResult) {
        return @"";
    }
    return _auditResult;
}

- (int)star {
    if (_star > 6) {
        return 6;
    }
    return _star;
}

@end

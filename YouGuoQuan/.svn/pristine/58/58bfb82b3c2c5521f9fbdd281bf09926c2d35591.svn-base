//
//  EaseAtTarget.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/25.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "EaseAtTarget.h"

@implementation EaseAtTarget

- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname {
    if (self = [super init]) {
        _userId = [userId copy];
        _nickname = [nickname copy];
    }
    return self;
}

- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname headImgUrl:(NSString *)imgUrl userLevel:(int)level userSex:(NSString *)sex vip:(BOOL)vip nobility:(BOOL)recommend {
    if (self = [super init]) {
        _userId     = [userId copy];
        _nickname   = [nickname copy];
        _headImgUrl = [imgUrl copy];
        _level      = level;
        _sex        = [sex copy];
        _vip        = vip;
        _recommend  = recommend;
    }
    return self;
}

@end


//
//  QiniuUploadHelper.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/1.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "QiniuUploadHelper.h"

@implementation QiniuUploadHelper

static id _instance = nil;

+ (id)allocWithZone:(struct _NSZone*)zone {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)sharedUploadHelper {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone*)zone {
    return _instance;
}

@end

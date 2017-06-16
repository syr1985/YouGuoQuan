//
//  LoginData.m
//  ShakeAround
//
//  Created by YM on 15/11/20.
//  Copyright © 2015年 erick. All rights reserved.
//

#import "LoginData.h"
#import <MJExtension.h>
#import "EMClient.h"
#import "UMessage.h"

@implementation LoginData

static LoginData *loginData = nil;
+ (instancetype)sharedLoginData {
    //    static dispatch_once_t once_token;
    //    dispatch_once(&once_token, ^{
    //        loginData = [LoginData alloc];
    //    });
    return loginData;
}

+ (instancetype)loginDataWithDict:(NSDictionary *)dict {
    [LoginData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"userId" : @"id", @"zfbAccount" : @"zfb", @"realName" : @"zfbRealName"};
    }];
    loginData = [[LoginData alloc] initLoginDataWithDict:dict];
    
    [[EMClient sharedClient] loginWithUsername:loginData.hxu password:loginData.hxp];
    
    [UMessage setAlias:loginData.userId type:@"youguoquan" response:nil];
    
    return loginData;
}

- (instancetype)initLoginDataWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [LoginData mj_objectWithKeyValues:dict];
        
        if (!self.headImg) {
            self.headImg = @"";
        }
        if (!self.nickName) {
            self.nickName = @"";
        }
        if (!self.auditResult) {
            self.auditResult = @"";
        }
        if (!self.publishWX) {
            self.publishWX = @"";
        }
        if (!self.publishWXPrice) {
            self.publishWXPrice = @"";
        }
    }
    return self;
}

- (int)star {
    if (_star > 6) {
        return 6;
    }
    return _star;
}

- (NSString *)zfbAccount {
    if (_zfbAccount) {
        return _zfbAccount;
    }
    return @"";
}

- (NSString *)realName {
    if (_realName) {
        return _realName;
    }
    return @"";
}

@end
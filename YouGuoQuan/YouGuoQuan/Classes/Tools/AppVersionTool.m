//
//  AppVersionTool.m
//  YouGuoQuan
//
//  Created by YM on 2017/6/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "AppVersionTool.h"
#import <AFNetworking.h>
#import "AlertViewTool.h"

#define AppStorePath    @"https://itunes.apple.com/lookup?id=1212759813"
#define AppItunesURL    @"itms-apps://itunes.apple.com/app/id1212759813"

@implementation AppVersionTool

+ (void)judgeAppStoreVersion {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:AppStorePath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *appInfo = (NSDictionary *)responseObject;
        NSArray *infoContent = [appInfo objectForKey:@"results"];
        NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
        NSString * appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([self compareVersionWithServiceVersion:version currentVersion:appVersion]) {
            //提示用户需要升级
            NSString *msg = [NSString stringWithFormat:@"当前版本号：%@，最新版本号：%@，是否去更新？", appVersion, version];
            [AlertViewTool showAlertViewWithTitle:@"发现新版本" Message:msg cancelTitle:@"忽略" sureTitle:@"去商店下载" sureBlock:^{
                [self downLoadNewVersionJumpAppStore];
            } cancelBlock:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"查询iTunes应用信息错误:%@",error.description);
    }];
}

//检查是都是最新版本
+ (BOOL)compareVersionWithServiceVersion:(NSString *)servierVersion currentVersion:(NSString *)appVersion {
    //NSLog(@"商店的版本是 %@",servierVersion);
    NSArray * serviceArr = [servierVersion componentsSeparatedByString:@"."];
    
    //NSString * appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //NSLog(@"当前的版本是 %@",appVersion);
    NSArray * appArr = [appVersion componentsSeparatedByString:@"."];
    
    if (!serviceArr.count) {
        return NO;
    } else {
        NSInteger compare = 0;
        if (serviceArr.count >= appArr.count) {
            compare = appArr.count;
        } else {
            compare = serviceArr.count;
        }
        for (int i = 0; i < compare; i++) {
            if ([serviceArr[i] integerValue] > [appArr[i] integerValue]) {
                return YES;
            } else if ([serviceArr[i] integerValue] == [appArr[i] integerValue]) {
                continue;
            } else {
                return NO;
            }
        }
        return NO;
    }
}

+ (void)downLoadNewVersionJumpAppStore {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:AppItunesURL]];
}

@end

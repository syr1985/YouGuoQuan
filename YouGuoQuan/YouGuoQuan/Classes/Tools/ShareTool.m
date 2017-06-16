//
//  ShareTool.m
//  YouGuoQuan
//
//  Created by YM on 2017/5/3.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ShareTool.h"
#import "UMSocialWechatHandler.h"
#import "NSString+Encrypt.h"

#define Share_URL @"http://www.youguowang.com/register.html?id="

@implementation ShareTool

+ (void)shareToPlatformType:(NSInteger)index viewController:(UIViewController *)vc {
    NSInteger type = UMSocialPlatformType_UnKnown;
    switch (index) {
        case 0:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2:
            type = UMSocialPlatformType_Sina;
            break;
        case 3:
            type = UMSocialPlatformType_QQ;
            break;
    }
   
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"与网红嫩模零距离"
                                                                             descr:@"私房写真、黑丝制服；人间胸器、激情热舞；在线互撩、线下相约。"
                                                                         thumImage:[UIImage imageNamed:@"shareLogo"]];
    
    NSString *webpageUrl = [NSString stringWithFormat:@"%@{%@}",Share_URL,[LoginData sharedLoginData].userId];
    
    //设置网页地址
    shareObject.webpageUrl = [webpageUrl URLEncoding]; 
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        }
    }];
}

@end

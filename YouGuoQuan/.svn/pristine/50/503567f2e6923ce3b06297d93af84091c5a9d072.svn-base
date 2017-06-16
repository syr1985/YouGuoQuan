//
//  IAPurchaseTool.h
//  YouGuoQuan
//
//  Created by YM on 2017/5/2.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APKit.h"

#define AppStoreInfoLocalFilePath [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"YgquanIAP"]

@interface IAPurchaseTool : NSObject
+ (instancetype)sharedInstance;
- (void)purchaseWithProductID:(NSString *)productID orderNo:(NSString *)orderNo;
- (void)purchaseWithProductID:(NSString *)productID orderNo:(NSString *)orderNo success:(void (^)())success failure:(void (^)())failure;
- (void)sendFailedIapFiles;
@end

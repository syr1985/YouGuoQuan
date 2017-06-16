//
//  PayTool.h
//  RoomService
//
//  Created by YM on 16/4/27.
//  Copyright © 2016年 SYR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FuqianlaPayTool : NSObject

/**
 *  此类已废弃，原来用到支付宝和微信支付，现在只有在充值时用到内购，其他消费均用钱包
 */
+ (void)payWithType:(NSString *)payType dataParam:(NSDictionary *)dataInfo success:(void (^)())success;

@end

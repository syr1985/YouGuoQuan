//
//  ActionSheetHelp.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/25.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayTool : NSObject

+ (void)payWithResult:(void (^)(NSString *payType))returnBlock;

+ (void)payFailureTranslateToViewController:(UIViewController *)vc;

+ (void)payFailureTranslateToRechargeVC:(UIViewController *)vc rechargeSuccess:(void (^)())success rechargeFailure:(void (^)())failure;

@end

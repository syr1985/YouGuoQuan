//
//  AlertViewTool.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertViewTool : NSObject

+ (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message buttonTitle:(NSString *)btnTitle sureBlock:(void (^)())sure;

+ (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message cancelTitle:(NSString *)cancel sureTitle:(NSString *)sureTitle sureBlock:(void (^)())sure cancelBlock:(void (^)())cancle;

+ (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message clickBlock:(void (^)(NSInteger index))clicked buttons:(NSDictionary *)buttons,...;

@end

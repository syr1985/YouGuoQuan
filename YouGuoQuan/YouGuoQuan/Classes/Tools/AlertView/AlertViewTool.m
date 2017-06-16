//
//  AlertViewTool.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "AlertViewTool.h"
#import "JCAlertView.h"

@implementation AlertViewTool

+ (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message buttonTitle:(NSString *)btnTitle sureBlock:(void (^)())sure {
    [JCAlertView showOneButtonWithTitle:title
                                Message:message
                             ButtonType:JCAlertViewButtonTypeCancel
                            ButtonTitle:btnTitle
                                  Click:^{
                                      if (sure) {
                                          sure();
                                      }
                                  }];
}

+ (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message cancelTitle:(NSString *)cancel sureTitle:(NSString *)sureTitle sureBlock:(void (^)())sure cancelBlock:(void (^)())cancle {
    [JCAlertView showTwoButtonsWithTitle:title
                                 Message:message
                              ButtonType:JCAlertViewButtonTypeCancel
                             ButtonTitle:cancel Click:^{
                                 if (cancle) {
                                     cancle();
                                 }
                             } ButtonType:JCAlertViewButtonTypeDefault
                             ButtonTitle:sureTitle Click:^{
                                 if (sure) {
                                     sure();
                                 }
                             }];
}

+ (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message clickBlock:(void (^)(NSInteger index))clicked buttons:(NSDictionary *)buttons,...{
    [JCAlertView showMultipleButtonsWithTitle:title
                                      Message:message
                                        Click:^(NSInteger index) {
                                            if (clicked) {
                                                clicked(index);
                                            }
                                        }
                                      Buttons:buttons, nil];
}

@end

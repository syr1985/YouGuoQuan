//
//  ActionSheetHelp.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/25.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PayTool.h"
#import <LCActionSheet.h>
#import "AlertViewTool.h"
#import "RechargeViewController.h"

@implementation PayTool

+ (void)payWithResult:(void (^)(NSString *payType))returnBlock {
    NSArray *otherTitleArray = @[@"充值余额"];//@"苹果商店支付",
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                                       clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                                                           if (buttonIndex != 0) {
                                                               NSString *payType = @"iap";
                                                               switch (buttonIndex) {
                                                                   case 2:
                                                                       payType = @"iap";
                                                                       break;
                                                                   case 1:
                                                                       payType = @"wallet";
                                                                       break;
                                                               }
                                                               returnBlock(payType);
                                                           }
                                                       }
                                         otherButtonTitleArray:otherTitleArray];
    [actionSheet show];
}

+ (void)payFailureTranslateToViewController:(UIViewController *)vc {
    [AlertViewTool showAlertViewWithTitle:nil Message:@"钱包余额不足，是否充值？" cancelTitle:@"取消" sureTitle:@"充值" sureBlock:^{
        UIStoryboard *walletSB = [UIStoryboard storyboardWithName:@"Wallet" bundle:nil];
        RechargeViewController *rechargeVC = [walletSB instantiateViewControllerWithIdentifier:@"RechargeVC"];
        rechargeVC.present = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rechargeVC];
        [vc presentViewController:nav animated:YES completion:nil];
    } cancelBlock:nil];
}

+ (void)payFailureTranslateToRechargeVC:(UIViewController *)vc rechargeSuccess:(void (^)())success rechargeFailure:(void (^)())failure {
    [AlertViewTool showAlertViewWithTitle:nil Message:@"钱包余额不足，是否充值？" cancelTitle:@"取消" sureTitle:@"充值" sureBlock:^{
        UIStoryboard *walletSB = [UIStoryboard storyboardWithName:@"Wallet" bundle:nil];
        RechargeViewController *rechargeVC = [walletSB instantiateViewControllerWithIdentifier:@"RechargeVC"];
        rechargeVC.present = YES;
        rechargeVC.successBlock = ^{
            [AlertViewTool showAlertViewWithTitle:nil Message:@"是否继续支付？" cancelTitle:@"取消" sureTitle:@"支付" sureBlock:^{
                if (success) {
                    success();
                }
            } cancelBlock:nil];
        };
        rechargeVC.failureBlock = ^{
            if (failure) {
                failure();
            }
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rechargeVC];
        [vc presentViewController:nav animated:YES completion:nil];
    } cancelBlock:nil];
}

@end

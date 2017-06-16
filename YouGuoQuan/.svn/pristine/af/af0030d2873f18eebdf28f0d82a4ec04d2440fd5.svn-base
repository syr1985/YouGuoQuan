//
//  AuthorityTool.m
//  YouGuoQuan
//
//  Created by YM on 2017/5/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "AuthorityTool.h"
#import "AlertViewTool.h"
#import "MyLevelViewController.h"
#import "OfficiallyCertifiedViewController.h"
#import "PayForNobilityViewController.h"

@implementation AuthorityTool

//+ (void)permissionDeniedTranslateToViewController:(UIViewController *)vc {
//    if ([vc isKindOfClass:[UITabBarController class]]) {
//        [AlertViewTool showAlertViewWithTitle:nil Message:@"您的权限不够，请升级权限!" cancelTitle:@"确定" sureTitle:@"查看权限" sureBlock:^{
//            UIStoryboard *centerSB = [UIStoryboard storyboardWithName:@"Center" bundle:nil];
//            MyLevelViewController *levelVC = [centerSB instantiateViewControllerWithIdentifier:@"MyLevelVC"];
//            levelVC.present = YES;
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:levelVC];
//            [vc presentViewController:nav animated:YES completion:nil];
//        } cancelBlock:^{
//            UITabBarController *tabbarVC = (UITabBarController *)vc;
//            tabbarVC.selectedIndex = 0;
//        }];
//    } else {
//        [AlertViewTool showAlertViewWithTitle:nil Message:@"您的权限不够，请升级权限!" cancelTitle:@"确定" sureTitle:@"查看权限" sureBlock:^{
//            UIStoryboard *centerSB = [UIStoryboard storyboardWithName:@"Center" bundle:nil];
//            MyLevelViewController *levelVC = [centerSB instantiateViewControllerWithIdentifier:@"MyLevelVC"];
//            levelVC.present = YES;
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:levelVC];
//            [vc presentViewController:nav animated:YES completion:nil];
//        } cancelBlock:nil];
//    }
//}

+ (void)chatPermissionDeniedFromViewController:(UIViewController *)fromVC returnBlock:(void (^)())handle {
    [AlertViewTool showAlertViewWithTitle:nil Message:@"请打赏或升级您的等级!" cancelTitle:@"打赏" sureTitle:@"查看等级" sureBlock:^{
        UIStoryboard *centerSB = [UIStoryboard storyboardWithName:@"Center" bundle:nil];
        MyLevelViewController *levelVC = [centerSB instantiateViewControllerWithIdentifier:@"MyLevelVC"];
        levelVC.present = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:levelVC];
        [fromVC presentViewController:nav animated:YES completion:nil];
    } cancelBlock:^{
        if (handle) {
            handle();
        }
    }];
}

+ (void)publishPermissionDeniedFromViewController:(UIViewController *)fromVC {
    [AlertViewTool showAlertViewWithTitle:nil Message:@"请进行官方认证或购买会员!" cancelTitle:@"官方认证" sureTitle:@"购买会员" sureBlock:^{
        [AuthorityTool pushToYouGuoNobilityVCFromVC:fromVC];
    } cancelBlock:^{
        [AuthorityTool pushToOfficiallyCertifiedVCFromVC:fromVC];
    }];
}

+ (void)publishProductPermissionDeniedFromViewController:(UIViewController *)fromVC {
    [AlertViewTool showAlertViewWithTitle:nil Message:@"请进行官方认证!" cancelTitle:@"确定" sureTitle:@"官方认证" sureBlock:^{
        [AuthorityTool pushToOfficiallyCertifiedVCFromVC:fromVC];
    } cancelBlock:nil];
}

+ (void)pushToOfficiallyCertifiedVCFromVC:(UIViewController *)fromVC {
    UIStoryboard *centerSB = [UIStoryboard storyboardWithName:@"Center" bundle:nil];
    OfficiallyCertifiedViewController *ocVC = [centerSB instantiateViewControllerWithIdentifier:@"OfficiallyCertifiedVC"];
    ocVC.present = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ocVC];
    [fromVC presentViewController:nav animated:YES completion:nil];
}

+ (void)pushToYouGuoNobilityVCFromVC:(UIViewController *)fromVC {
    UIStoryboard *centerSB = [UIStoryboard storyboardWithName:@"Center" bundle:nil];
    PayForNobilityViewController *nobilityVC = [centerSB instantiateViewControllerWithIdentifier:@"PayForNobilityVC"];
    nobilityVC.present = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nobilityVC];
    [fromVC presentViewController:nav animated:YES completion:nil];
}

@end

//
//  PersonalInfoViewController.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/14.
//  Copyright © 2016年 NT. All rights reserved.
//

//#import "BaseViewController.h"
#import <UIKit/UIKit.h>

extern NSString * const kNotification_LoginSuccess;

@interface PersonalInfoViewController : UIViewController
@property (nonatomic,   copy) NSString *telephoneNumber;
@property (nonatomic,   copy) NSString *password;
@end


//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
//                                                                       message:@"该手机号已经注册尤果圈账号，是否使用新密码登录？"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
//                                                             style:UIAlertActionStyleDefault
//                                                           handler:^(UIAlertAction * action) {
//                                                               __weak typeof(self) weakself = self;
//                                                               [NetworkTool resetPasswordWithPhone:_telephoneNumber Password:_password Result:^{
//                                                                   [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
//                                                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                                                       [weakself.navigationController popToRootViewControllerAnimated:YES];
//                                                                   });
//                                                               }];
//                                                           }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
//                                                               style:UIAlertActionStyleCancel
//                                                             handler:^(UIAlertAction * action) {
//
//                                                             }];
//        [alert addAction:sureAction];
//        [alert addAction:cancelAction];
//        [self presentViewController:alert animated:YES completion:nil];

//
//  FillInAccountViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/21.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "FillInAccountViewController.h"
#import "WithdrawCashViewController.h"

@interface FillInAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@end

@implementation FillInAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"提现";

    if ([LoginData sharedLoginData].audit == 1 || [LoginData sharedLoginData].audit == 3) {
        _accountTextField.text = [LoginData sharedLoginData].zfbAccount;
        _confirmTextField.text = [LoginData sharedLoginData].zfbAccount;
        _realNameTextField.text = [LoginData sharedLoginData].realName;
        _accountTextField.enabled = NO;
        _confirmTextField.enabled = NO;
        _realNameTextField.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStepButtonClicked:(id)sender {
    if (_accountTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入支付宝账号"];
        return;
    }
    
    if (![_accountTextField.text isEqualToString:_confirmTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入支付宝账号不一致"];
        return;
    }
    
    if (_realNameTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入支付宝实名"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"提交申请"];
    [NetworkTool walletWithdrawCashWithMoney:_totalWithCash realName:_realNameTextField.text account:_accountTextField.text Success:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"提现申请已发出，请耐心等待"];
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *destVC = weakself.navigationController.viewControllers[2];
            [weakself.navigationController popToViewController:destVC animated:YES];
        });
    } failure:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"提现申请提交失败"];
    }];
}

@end

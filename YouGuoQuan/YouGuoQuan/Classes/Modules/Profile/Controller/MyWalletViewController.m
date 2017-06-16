//
//  MyWalletViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MyWalletViewController.h"
#import "WithdrawCashViewController.h"
#import "RechargeRecordViewController.h"
#import "AlertViewTool.h"
#import "UserBaseInfoModel.h"

@interface MyWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rechargeBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeBalanceLabel;
@end

@implementation MyWalletViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"我的钱包";
    
    //self.incomeBalanceLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:48];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [NetworkTool getMyWalletInfoSuccess:^(id result){
        NSMutableString *muTotal = [NSMutableString stringWithString:[result[@"totalMoney"] stringValue]];
        if (muTotal.length > 3) {
            for (NSInteger i = muTotal.length - 3; i > 0; i -= 3) {
                [muTotal insertString:@"," atIndex:i];
            }
        }
        self.rechargeBalanceLabel.text = [muTotal copy];
        NSMutableString *muIncome = [NSMutableString stringWithString:[result[@"incomeMoney"] stringValue]];
        if (muIncome.length > 3) {
            for (NSInteger i = muIncome.length - 3; i > 0; i -= 3) {
                [muIncome insertString:@"," atIndex:i];
            }
        }
        self.incomeBalanceLabel.text   = [muIncome copy];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"获取我的钱包数据失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"IncomeRecordSegue"]) {
        RechargeRecordViewController *rechargeVC = (RechargeRecordViewController *)destVC;
        rechargeVC.titleString = @"收入明细";
    } else if ([segue.identifier isEqualToString:@"RechargeRecordSegue"]) {
        RechargeRecordViewController *rechargeVC = (RechargeRecordViewController *)destVC;
        rechargeVC.titleString = @"账单明细";
    } else if ([segue.identifier isEqualToString:@"WithdrawCashSegue"]) {
        WithdrawCashViewController *withdrawCashVC = (WithdrawCashViewController *)destVC;
        withdrawCashVC.totalIncome = self.incomeBalanceLabel.text;
    }
}

@end

//
//  BuyWeiXinViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/23.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "BuyWeiXinViewController.h"
#import "NSString+AttributedText.h"
#import "IAPurchaseTool.h"
#import "PayTool.h"

@interface BuyWeiXinViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *orderNo;
@end

@implementation BuyWeiXinViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.payType = @"wallet";
    __weak typeof(self) weakself = self;
    [NetworkTool generateOrderNoWithGoodsType:@"WX" success:^(id result) {
        weakself.orderNo = result;
    } failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.priceLabel.text = [NSString stringWithFormat:@"打赏%@u币",_price];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 只剩一种支付方式，此方法没用
- (IBAction)payTypeSelected:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected = YES;
        switch (sender.superview.tag) {
            case 1:
                self.payType = @"iap";
                break;
            case 0:
                self.payType = @"wallet";
                break;
        }
        UIStackView *stackView = (UIStackView *)sender.superview.superview;
        for (UIView *view in stackView.subviews) {
            if (view != sender.superview) {
                UIButton *btn = [view viewWithTag:1000];
                btn.selected = NO;
            }
        }
    }
}

- (IBAction)buyWeixinButtonClicked {
    if (_accountTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入微信号"];
    } else {
        // 钱包
        __weak typeof(self) weakself = self;
        [NetworkTool createWeiXinOrderWithSalerId:_salerID payMethod:_payType orderNo:_orderNo weixin:_accountTextField.text success:^(id result, id payOrderNo) {
            if ([weakself.payType isEqualToString:@"wallet"]) {
                [weakself payByWalletWithOrderNo:result];
            } else {
                // IAP
//                NSString *productID = [NSString stringWithFormat:@"youguoquan.weixin%@u",_price];
//                [[IAPurchaseTool sharedInstance] purchaseWithProductID:productID orderNo:result success:^{
//                     [weakself dismissViewControllerAfterShowMessage];
//                } failure:^{
//                     [weakself dismissViewControllerAfterShowMessage];
//                }];
            }
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
        }];
    }
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo {
    [NetworkTool payForTrendsToMiddleAccountWithOrderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakself.payRewardSucess) {
                weakself.payRewardSucess();
            }
            [weakself dismissViewController:nil];
        });
    } failure:^(NSError *error, NSString *msg){
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [self dismissViewControllerAfterShowMessage];
        } else if ([msg isEqualToString:@"金额不足"]) {
            [PayTool payFailureTranslateToRechargeVC:self rechargeSuccess:^{
                [self payByWalletWithOrderNo:orderNo];
            } rechargeFailure:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            [self dismissViewControllerAfterShowMessage];
        }
    }];
}

- (void)dismissViewControllerAfterShowMessage {
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
    });
}

@end

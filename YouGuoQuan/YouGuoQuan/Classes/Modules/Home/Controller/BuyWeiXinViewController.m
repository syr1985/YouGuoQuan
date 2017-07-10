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
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
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
    [NetworkTool generateOrderNoWithGoodsType:@"WX" success:^(id result) {
        self.orderNo = result;
    } failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_price) {
        NSString *giftName = @"";
        switch (_price.integerValue) {
            case 999:
                giftName = @"口红";
                break;
            case 1314:
                giftName = @"香水";
                break;
            case 5200:
                giftName = @"耳坠";
                break;
            case 6666:
                giftName = @"项链";
                break;
            case 8888:
                giftName = @"手镯";
                break;
            case 9999:
                giftName = @"钻戒";
                break;
            case 19999:
                giftName = @"跑车";
                break;
            case 29999:
                giftName = @"游艇";
                break;
            case 59999:
                giftName = @"别墅";
                break;
        }
        self.priceLabel.text = [NSString stringWithFormat:@"%@ 售价：%@ u币", giftName, _price];
        self.giftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"购买微信-%@",giftName]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 只剩一种支付方式，此方法没用
//- (IBAction)payTypeSelected:(UIButton *)sender {
//    if (!sender.isSelected) {
//        sender.selected = YES;
//        switch (sender.superview.tag) {
//            case 1:
//                self.payType = @"iap";
//                break;
//            case 0:
//                self.payType = @"wallet";
//                break;
//        }
//        UIStackView *stackView = (UIStackView *)sender.superview.superview;
//        for (UIView *view in stackView.subviews) {
//            if (view != sender.superview) {
//                UIButton *btn = [view viewWithTag:1000];
//                btn.selected = NO;
//            }
//        }
//    }
//}

//            if ([weakself.payType isEqualToString:@"wallet"]) {
//
//            } else {
//                // IAP
//                NSString *productID = [NSString stringWithFormat:@"youguoquan.weixin%@u",_price];
//                [[IAPurchaseTool sharedInstance] purchaseWithProductID:productID orderNo:result success:^{
//                     [weakself dismissViewControllerAfterShowMessage];
//                } failure:^{
//                     [weakself dismissViewControllerAfterShowMessage];
//                }];
//            }

- (IBAction)buyWeixinButtonClicked {
    if (_accountTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入微信号"];
    } else {
        [NetworkTool createWeiXinOrderWithSalerId:_salerID
                                        payMethod:_payType
                                          orderNo:_orderNo
                                           weixin:_accountTextField.text
                                          success:^(id result, id payOrderNo) {
                                              [self payByWalletWithOrderNo:result];
                                          } failure:^{
                                              [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
                                          }];
    }
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo {
    [NetworkTool payForTrendsToMiddleAccountWithOrderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.payWeiXinSucess) {
                self.payWeiXinSucess();
            }
            [self dismissViewController:nil];
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

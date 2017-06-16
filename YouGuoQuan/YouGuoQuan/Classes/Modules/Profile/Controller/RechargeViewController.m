//
//  RechargeViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/6.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "RechargeViewController.h"
#import "PayTool.h"
#import "IAPurchaseTool.h"
#import "FuqianlaPayTool.h"

@interface RechargeViewController ()
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic,   copy) NSString *money;
@property (nonatomic,   copy) NSString *orderNo;
@end

@implementation RechargeViewController
    
- (void)dealloc {
    NSLog(@"%s",__func__);
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"充值";
    
    __weak typeof(self) weakself = self;
    [NetworkTool generateOrderNoWithGoodsType:@"FW" success:^(id result) {
        weakself.orderNo = result;
    } failure:nil];
    
    if (_present) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(dismissViewController)];
        leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (IBAction)selectRechargeAmountButtonClicked:(UIButton *)sender {
    if (sender == _selectButton) {
        return;
    }
    if (_selectButton) {
        _selectButton.selected = NO;
    }
    sender.selected = YES;
    _selectButton = sender;
    if (sender.tag == 6) {
        _money = @"42";
    } else if (sender.tag == 12) {
        _money = @"84";
    } else if (sender.tag == 50) {
        _money = @"350";
    } else if (sender.tag == 128) {
        _money = @"1031";
    } else if (sender.tag == 218) {
        _money = @"1606";
    } else if (sender.tag == 388) {
        _money = @"2852";
    } else if (sender.tag == 998) {
        _money = @"7685";
    } else if (sender.tag == 1998) {
        _money = @"15385";
    } else if (sender.tag == 3998) {
        _money = @"30785";
    }
}
    
- (IBAction)rechargeButtonClicked:(id)sender {
    if (!_money) {
        [SVProgressHUD showInfoWithStatus:@"请选择充值金额"];
        return;
    }
    NSString *productID = [NSString stringWithFormat:@"recharge%@u",_money];
    __weak typeof(self) weakself = self;
    [NetworkTool createRechargeOrderWithOrderNo:_orderNo
                                          money:_money
                                      payMethod:@"iap"
                                        success:^(id result, id payOrderNo) {
        [SVProgressHUD showWithStatus:@"充值正在进行中，完成前请先不要离开"];
        [[IAPurchaseTool sharedInstance] purchaseWithProductID:productID orderNo:result success:^{
            [SVProgressHUD showInfoWithStatus:@"充值成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakself.successBlock) {
                    weakself.successBlock();
                }
                if (_present) {
                    [self dismissViewController];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        } failure:^{
            [SVProgressHUD showInfoWithStatus:@"充值失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakself.failureBlock) {
                    weakself.failureBlock();
                }
                if (_present) {
                    [self dismissViewController];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
    }];
}

@end

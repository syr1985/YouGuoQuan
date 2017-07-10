//
//  LookPhotosViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/4.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "LookPhotosViewController.h"
#import <UIImageView+WebCache.h>
#import "NSString+AttributedText.h"
#import "PayTool.h"
#import "IAPurchaseTool.h"
#import "AlertViewTool.h"

@interface LookPhotosViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,   copy) NSString *orderNo;
@end

@implementation LookPhotosViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_price) {
        NSString *giftName = @"";
        switch (_price) {
            case 10:
                giftName = @"爱心";
                break;
            case 30:
                giftName = @"棒棒糖";
                break;
            case 60:
                giftName = @"玫瑰花";
                break;
            case 80:
                giftName = @"冰淇淋";
                break;
        }
        _giftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"看红包照片-%@",giftName]];
        _moneyLabel.text = [NSString stringWithFormat:@"%@ 售价：%zd u币",giftName, _price];
    }

    [NetworkTool generateOrderNoWithGoodsType:@"RP" success:^(id result) {
        self.orderNo = result;
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buyButtonClicked:(id)sender {
//    [PayTool payWithResult:^(NSString *payType) {
//        __weak typeof(self) weakself = self;
//        [NetworkTool createRedPacketOrderWithGoodsId:_goodsId
//                                             feedsId:_feedsId
//                                           payMethod:payType
//                                               phone:@""
//                                             orderNo:_orderNo
//                                             success:^(id result, id payOrderNo) {
//            if ([payType isEqualToString:@"wallet"]) {
//                [weakself payByWalletWithOrderNo:result];
//            } else {
////                NSString *productID = [NSString stringWithFormat:@"youguoquan.photo%zdu",_price];
////                [[IAPurchaseTool sharedInstance] purchaseWithProductID:productID orderNo:result success:^{
////                     [weakself dismissViewControllerAfterShowMessage];
////                } failure:^{
////                     [weakself dismissViewControllerAfterShowMessage];
////                }];
//            }
//        } failure:^{
//            [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
//        }];
//    }];
    [NetworkTool createRedPacketOrderWithGoodsId:_goodsId
                                         feedsId:_feedsId
                                       payMethod:@"wallet"
                                           phone:@""
                                         orderNo:_orderNo
                                         success:^(id result, id payOrderNo) {
                                             [self payByWalletWithOrderNo:result];
                                         } failure:^{
                                             [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
                                         }];
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo {
    [NetworkTool payForTrendsToUserDirectlyWithOrderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [self successPayForBuyPhoto];
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

- (void)successPayForBuyPhoto {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserCenterBuyPhotoSuccessNotification
                                                        object:nil
                                                      userInfo:@{@"PhotoFeedsID":self.feedsId}];
    [self dismissViewControllerAfterShowMessage];
}

- (void)dismissViewControllerAfterShowMessage {
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
    });
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

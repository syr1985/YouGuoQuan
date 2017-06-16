//
//  RewardViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/2.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "RewardViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PayTool.h"
#import "IAPurchaseTool.h"

@interface RewardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic,   copy) NSString *orderNo;
@end

@implementation RewardViewController

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _headerImageView.layer.cornerRadius = _headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:_headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    __weak typeof(self) weakself = self;
    [NetworkTool generateOrderNoWithGoodsType:@"RE" success:^(id result) {
        weakself.orderNo = result;
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s",__func__);
}

- (IBAction)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  塞红包
 */
- (IBAction)payForReward {
    if (_currentTag == 0) {
        [SVProgressHUD showInfoWithStatus:@"您还未选择红包金额"];
        return;
    }
    NSString *money = [NSString stringWithFormat:@"%zd",_currentTag * 10];
    __weak typeof(self) weakself = self;
    [PayTool payWithResult:^(NSString *payType) {
        [NetworkTool createRewardOrderWithUserID:_userID
                                           money:money
                                       payMethod:payType
                                           rType:_rType
                                            memo:@""
                                         orderNo:_orderNo
                                         success:^(id result, id payOrderNo) {
            if ([payType isEqualToString:@"wallet"]) {
                [weakself payByWalletWithOrderNo:result payMethod:payType];
            } else {
//                NSString *productID = [NSString stringWithFormat:@"youguoquan.reward%zdu",_currentTag * 10];
//                [[IAPurchaseTool sharedInstance] purchaseWithProductID:productID orderNo:result success:^{
//                    [weakself dismissViewControllerAfterShowMessage];
//                } failure:^{
//                    [weakself dismissViewControllerAfterShowMessage];
//                }];
            }
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
        }];
    }];
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo payMethod:(NSString *)payType {
    [NetworkTool payForRewardWithOrderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"打赏成功"];
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakself.payRewardSucess) {
                weakself.payRewardSucess(weakself.currentTag * 10, payType);
            }
            [weakself dismissViewController];
        });
    } failure:^(NSError *error, NSString *msg){
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [self dismissViewControllerAfterShowMessage];
        } else if ([msg isEqualToString:@"金额不足"]) {
            [PayTool payFailureTranslateToRechargeVC:self rechargeSuccess:^{
                [self payByWalletWithOrderNo:orderNo payMethod:payType];
            } rechargeFailure:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"打赏失败"];
            [self dismissViewControllerAfterShowMessage];
        }
    }];
}

- (void)dismissViewControllerAfterShowMessage {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewController];
    });
}

- (IBAction)redEnvelopeSelected:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        if (sender.tag != _currentTag) {
            if (_currentTag != 0) {
                UIButton *btn = [self.view viewWithTag:_currentTag];
                btn.selected = NO;
            }
            _currentTag = sender.tag;
        }
    } else {
        _currentTag = 0;
    }
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

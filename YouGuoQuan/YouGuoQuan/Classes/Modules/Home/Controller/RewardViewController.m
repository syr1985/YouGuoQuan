//
//  RewardViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/2.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "RewardViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IAPurchaseTool.h"

@interface RewardViewController ()
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
    
    [NetworkTool generateOrderNoWithGoodsType:@"RE" success:^(id result) {
        self.orderNo = result;
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s",__func__);
}

- (IBAction)tapBackgroundViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapViewToReward:(UITapGestureRecognizer *)sender {
    //NSLog(@"%zd",sender.view.tag);
    UIView *tapView = sender.view;
    
    UIImageView *imageView = [tapView viewWithTag:1];
    imageView.layer.borderColor = NavTabBarColor.CGColor;
    imageView.layer.borderWidth = 1;
    
    UILabel *titleLabel = [tapView viewWithTag:2];
    titleLabel.textColor = NavTabBarColor;
    
    UILabel *priceLabel = [tapView viewWithTag:3];
    priceLabel.textColor = NavTabBarColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createPayOrderWithPrice:@(sender.view.tag)];
    });
}

- (void)createPayOrderWithPrice:(NSNumber *)price {
    [NetworkTool createRewardOrderWithUserID:_userID
                                       money:price.stringValue
                                   payMethod:@"wallet"
                                       rType:_rType
                                        memo:@""
                                     orderNo:_orderNo
                                     success:^(id result, id payOrderNo) {
                                         [self dismissViewControllerAnimated:YES completion:^{
                                             if (self.payForReward) {
                                                 self.payForReward(price, @"wallet", result);
                                             }
                                         }];
                                     } failure:^{
                                         [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
                                     }];
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

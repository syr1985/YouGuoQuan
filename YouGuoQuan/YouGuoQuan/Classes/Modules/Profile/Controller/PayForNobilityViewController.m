//
//  PayForNobilityViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/6.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "PayForNobilityViewController.h"
#import "PayTool.h"
#import "IAPurchaseTool.h"
#import "UserDefaultsTool.h"
#import "UserBaseInfoModel.h"

NSString * const kNotification_BuyVipSuccess = @"kNotification_BuyVIPSuccess";

@interface PayForNobilityViewController () <UITableViewDelegate>
@property (nonatomic,   copy) NSString *orderNo;
@end

@implementation PayForNobilityViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"尤果VIP会员";
    
    __weak typeof(self) weakself = self;
    [NetworkTool generateOrderNoWithGoodsType:@"NB" success:^(id result) {
        weakself.orderNo = result;
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSArray *vipPrice = @[@{@"month":@(0), @"price":@998},
                              @{@"month":@(12),@"price":@588},
                              @{@"month":@(6), @"price":@388},
                              @{@"month":@(3), @"price":@238},
                              @{@"month":@(1), @"price":@98}];
        NSDictionary *infoDict = vipPrice[indexPath.row];
        NSNumber *price = infoDict[@"price"];
        NSInteger priceInteger = [price integerValue];
        [NetworkTool createBuyNobilityOrderWithOrderNo:_orderNo money:@(priceInteger * 7) payMethod:@"iap" month:infoDict[@"month"] success:^(id result, id payOrderNo) {
            //NSLog(@"%@",result);
            [SVProgressHUD showWithStatus:@"购买正在进行中，完成前请先不要离开"];
            NSString *productID = [NSString stringWithFormat:@"vip%@", price];
            [[IAPurchaseTool sharedInstance] purchaseWithProductID:productID orderNo:result success:^{
                [self paymentSuccess];
            } failure:^{
                [self paymentFailure];
            }];
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
        }];
    }
}

- (void)paymentSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_BuyVipSuccess object:nil];
    [LoginData sharedLoginData].isRecommend = YES;
    [UserDefaultsTool saveLoginData];
    [SVProgressHUD showInfoWithStatus:@"购买尤果VIP会员成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_modifyRecommandBlock) {
            _modifyRecommandBlock();
        }
        [self popViewController];
    });
}

- (void)paymentFailure {
    [SVProgressHUD showInfoWithStatus:@"购买尤果VIP会员失败"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self popViewController];
    });
}

- (void)popViewController {
    if (_present) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end

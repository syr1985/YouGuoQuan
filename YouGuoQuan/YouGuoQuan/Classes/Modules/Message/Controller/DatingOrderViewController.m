//
//  DatingOrderViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/28.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "DatingOrderViewController.h"
#import "POISearchViewController.h"
#import "YGDatePickerView.h"
#import "PayTool.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface DatingOrderViewController () <UITextFieldDelegate, YGDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *dateTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *applePayButton;
@property (weak, nonatomic) IBOutlet UIButton *walletPayButton;
@property (nonatomic, strong) YGDatePickerView *datePicker;
@property (nonatomic,   copy) NSString *currentPayMethod;
@property (nonatomic,   copy) NSString *orderNo;
@end

@implementation DatingOrderViewController

- (YGDatePickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[YGDatePickerView alloc] init];
        _datePicker.delegate = self;
    }
    return _datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleString = @"提交预约";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 55)];
    headerView.backgroundColor = BackgroundColor;
    
    UILabel *warningTips = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, WIDTH - 20, 31)];
    //warningTips.text = @"*预约如未成功，资金将返还，如有违法及不道德行为，平台将有权将该款项划拨给对方";
    warningTips.numberOfLines = 0;
    warningTips.font = [UIFont systemFontOfSize:10];
    warningTips.textColor = WarningTipsTextColor;
    warningTips.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    warningTips.attributedText = [[NSAttributedString alloc] initWithString:@"*预约如未成功，资金将返还，如有违法及不道德行为，平台将有权将该款项划拨给对方" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [warningTips sizeToFit];
    [headerView addSubview:warningTips];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UILabel *moneyIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 48)];
    moneyIcon.font = [UIFont systemFontOfSize:14];
    moneyIcon.textColor = NavTabBarColor;
    moneyIcon.text = @"¥";
    _moneyTextField.leftView = moneyIcon;
    _moneyTextField.leftViewMode = UITextFieldViewModeAlways;
    
    __weak typeof(self) weakself = self;
    [NetworkTool generateOrderNoWithGoodsType:@"DT" success:^(id result) {
        weakself.orderNo = result;
    } failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dateTypeLabel.text = [NSString stringWithFormat:@"%@活动",_dateType];
    _dateTypeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"购买订单-约见-%@",_dateType]];
}

- (IBAction)payMethodButtonClicked:(UIButton *)sender {
    if ([sender isEqual:_applePayButton]) {
        _currentPayMethod = @"iap";
        _applePayButton.selected = YES;

        _walletPayButton.selected = NO;
    } else {
        _currentPayMethod = @"wallet";
        _applePayButton.selected = NO;
        _walletPayButton.selected = YES;
    }
}

- (IBAction)sureToPayButtonClicked:(id)sender {
    NSInteger amount = [_moneyTextField.text integerValue];
    if (amount < 100) {
        [SVProgressHUD showInfoWithStatus:@"赏金不能低于100元"];
        return;
    }
    
    if (!_dateTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请选择约见时间"];
        return;
    }
    
    if (!_addressTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请选择约见地址"];
        return;
    }
    
    __weak typeof(self) weakself = self;
    [NetworkTool createDateOrderWithOrderNo:_orderNo serviceName:_dateType payMethod:_currentPayMethod salerId:_userId price:_moneyTextField.text dateTimeInfo:_dateTextField.text dateAddress:_addressTextField.text success:^(id result, id payOrderNo) {
        if ([weakself.currentPayMethod isEqualToString:@"wallet"]) {
            [self payByWalletWithOrderNo:result];
        } else {
//            NSDictionary *payInfo = @{@"orderNo" : payOrderNo,
//                                      @"amount"  : weakself.moneyTextField.text,
//                                      @"subject" : result,
//                                      @"desc"    : [NSString stringWithFormat:@"约见-%@",weakself.dateType]};
//            [FuqianlaPayTool payWithType:weakself.currentPayMethod dataParam:payInfo success:^{
//                [SVProgressHUD showSuccessWithStatus:@"您的约见请求已送出，请耐心等待"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakself dismissViewControllerAnimated:YES completion:nil];
//                });
//            }];
        }
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
    }];
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo {
    [NetworkTool payForTrendsToMiddleAccountWithOrderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"您的约见请求已送出，请耐心等待"];
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSError *error, NSString *msg){
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else if ([msg isEqualToString:@"金额不足"]) {
            [PayTool payFailureTranslateToRechargeVC:self rechargeSuccess:^{
                [self payByWalletWithOrderNo:orderNo];
            } rechargeFailure:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"约见失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_dateTextField]) {
        [textField resignFirstResponder];
        [self.datePicker show];
    } else if ([textField isEqual:_addressTextField]) {
        [textField resignFirstResponder];
        UIStoryboard *messageSB = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
        POISearchViewController *chooseVC = [messageSB instantiateViewControllerWithIdentifier:@"POISearchVC"];
        __weak typeof(self) weakself = self;
        chooseVC.sendLocationInfo = ^(AMapPOI *poi, NSString *mapImageURL) {
            weakself.addressTextField.text = poi.address;
        };
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
}

#pragma mark - YGDatePickerViewDelegate
- (void)didPickDate:(NSDate *)date pickerView:(YGDatePickerView *)pickerView {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.dateTextField.text = [dateFormatter stringFromDate:date];
    [self.tableView reloadData];
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
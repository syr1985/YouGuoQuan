//
//  SellWeixinViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PublishWeiXinViewController.h"
#import "ChooseWeiXinPriceViewController.h"
#import "MySoldOrderViewController.h"
#import "AlertViewTool.h"
#import "UserDefaultsTool.h"

@interface PublishWeiXinViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (nonatomic, strong) NSNumber *price;
@end

@implementation PublishWeiXinViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BackgroundColor;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UIView *accountLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 36)];
    UIImageView *accountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 6, 24, 24)];
    accountImageView.image = [UIImage imageNamed:@"输入微信"];
    [accountLeftView addSubview:accountImageView];
    self.accountTextField.leftView = accountLeftView;
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *priceLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 36)];
    UIImageView *priceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 6, 24, 24)];
    priceImageView.image = [UIImage imageNamed:@"发布价格"];
    [priceLeftView addSubview:priceImageView];
    self.priceTextField.leftView = priceLeftView;
    self.priceTextField.leftViewMode = UITextFieldViewModeAlways;
    
    if ([LoginData sharedLoginData].havePublishWX) {
        __weak typeof(self) weakself = self;
        [AlertViewTool showAlertViewWithTitle:nil Message:@"您已经发布过微信！" cancelTitle:@"变更发布" sureTitle:@"打赏列表" sureBlock:^{
            [weakself pushToBuyerListViewController];
        } cancelBlock:^{
            weakself.accountTextField.text = [LoginData sharedLoginData].publishWX;
            weakself.priceTextField.text = [LoginData sharedLoginData].publishWXPrice;
        }];
    } else {
        UIStoryboard *publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
        UIViewController *publishRuleVC = [publishSB instantiateViewControllerWithIdentifier:@"PublishWeiXinRuleVC"];
        publishRuleVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:publishRuleVC animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![LoginData sharedLoginData].userId) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToBuyerListViewController {
    UIStoryboard *soldSB = [UIStoryboard storyboardWithName:@"Sold" bundle:nil];
    MySoldOrderViewController *soldVC = [soldSB instantiateInitialViewController];
    soldVC.fromSellWeixinPage = YES;
    [self.navigationController pushViewController:soldVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _priceTextField) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_priceTextField resignFirstResponder];
            UIStoryboard *publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
            ChooseWeiXinPriceViewController *choosePriceVC = [publishSB instantiateViewControllerWithIdentifier:@"ChooseWeiXinPriceVC"];
            choosePriceVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            __weak typeof(self) weakself = self;
            choosePriceVC.selectPublishPriceBlock = ^(NSString *text, NSNumber *price) {
                weakself.price = price;
                weakself.priceTextField.text = text;
            };
            [self presentViewController:choosePriceVC animated:YES completion:nil];
        });
    }
}

#pragma mark -
#pragma mark - 关闭页面
- (IBAction)dismissViewController {
    __weak typeof(self) weakself = self;
    [AlertViewTool showAlertViewWithTitle:nil Message:@"您确认放弃此次操作吗？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
    } cancelBlock:nil];
}

- (IBAction)sureSellButtonClicked:(id)sender {
    NSString *wxId = _accountTextField.text;
    if (!wxId || !wxId.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入微信账号"];
        return;
    }
    NSString *price = _priceTextField.text;
    if (!price || !price.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入发布价格"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"发布微信"];
    __weak typeof(self) weakself = self;
    [NetworkTool sellWeixin:_price weixinID:wxId success:^{
        [SVProgressHUD showSuccessWithStatus:@"发布微信成功"];
        [LoginData sharedLoginData].havePublishWX = YES;
        [LoginData sharedLoginData].publishWX = wxId;
        [LoginData sharedLoginData].publishWXPrice = price;
        
        [UserDefaultsTool saveLoginData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakself dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"发布微信失败"];
        [SVProgressHUD dismissWithDelay:HUD_SHOW_TIME];
    }];
}

@end
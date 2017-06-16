//
//  ProductOrderViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/29.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ProductOrderViewController.h"

#import "OrderInfoViewCell.h"
#import "CrowdfundingInfoViewCell.h"
#import "PayTypeViewCell.h"
#import "OrderMessageViewCell.h"

#import "HomeFocusModel.h"
#import "NSString+StringSize.h"
#import "IAPurchaseTool.h"
#import "PayTool.h"

@interface ProductOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *surePayButton;
@property (nonatomic, strong) NSArray *inputArray;
@property (nonatomic, strong) NSArray *payTypeArray;

@property (nonatomic,   copy) NSString *inputTelNum;
@property (nonatomic,   copy) NSString *inputEmail;
@property (nonatomic,   copy) NSString *inputMessage;

@property (nonatomic, assign) NSUInteger currentPayIndex;
@property (nonatomic,   copy) NSString *orderNo;
@end

static NSString * const tableViewCellID_OrderInput = @"OrderInfoViewCell";
static NSString * const tableViewCellID_CrowdInfo  = @"CrowdfundingInfoViewCell";
static NSString * const tableViewCellID_PayType    = @"PayTypeViewCell";
static NSString * const tableViewCellID_Message    = @"OrderMessageViewCell";

@implementation ProductOrderViewController

#pragma mark -
#pragma mark - 懒加载
- (NSArray *)inputArray {
    if (!_inputArray) {
        _inputArray = @[@{@"title":@"电话：", @"placeholder":@"请输入电话"},
                        @{@"title":@"邮箱：", @"placeholder":@"请输入邮箱"}];
    }
    return _inputArray;
}

- (NSArray *)payTypeArray {
    if (!_payTypeArray) {
        _payTypeArray = @[@{@"imageName":@"钱包支付", @"title":@"钱包零钱支付"}];
    }
    return _payTypeArray;
}

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    
    UIView *headView = [[UIView alloc] init];
    headView.bounds = CGRectMake(0, 0, WIDTH, 35);
    headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UILabel *waringLabel = [[UILabel alloc] init];
    waringLabel.frame = CGRectMake(10, 0, WIDTH - 20, 35);
    waringLabel.textColor = [UIColor redColor];
    waringLabel.text = @"*请务必核对正确邮箱，若预留邮箱错误，平台与商户免责";
    waringLabel.numberOfLines = 0;
    waringLabel.font = [UIFont systemFontOfSize:12];
    [headView addSubview:waringLabel];
    self.tableView.tableHeaderView = headView;
    
    self.navigationController.navigationBar.hidden = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(dismissViewController)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    
    __weak typeof(self) weakself = self;
    [NetworkTool generateOrderNoWithGoodsType:@"NM" success:^(id result) {
        weakself.orderNo = result;
    } failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.surePayButton setTitle:[NSString stringWithFormat:@"确认支付 %@ u币",_homeFocusModel.price]
                        forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)surePayButtonClicked:(UIButton *)sender {
    if (_inputTelNum == nil || _inputTelNum.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![HelperUtil checkTelNumber:_inputTelNum]) {
        [SVProgressHUD showInfoWithStatus:@"请输入有效手机号码"];
        return;
    }
    
    if (_inputEmail == nil || _inputEmail.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入邮箱号"];
        return;
    }
    
    if (![HelperUtil checkMailInput:_inputEmail]) {
        [SVProgressHUD showInfoWithStatus:@"请输入有效邮箱号码"];
        return;
    }
    
    NSString *desc = _inputMessage ? _inputMessage : @"";
    
    NSString *payType;
    switch (_currentPayIndex) {
        case 1:
            payType = @"iap";
            break;
        case 0:
            payType = @"wallet";
            break;
    }
    __weak typeof(self) weakself = self;
    [NetworkTool createOrderWithGoodsId:_homeFocusModel.goodsId feedsId:@"" payMethod:payType phone:_inputTelNum email:_inputEmail desc:desc orderNo:_orderNo success:^(id result, id payOrderNo) {
        if ([payType isEqualToString:@"wallet"]) {
            [weakself payByWalletWithOrderNo:result];
        } else {
//            NSString *productID = [NSString stringWithFormat:@"youguoquan.product%@u",_homeFocusModel.price];
//            [[IAPurchaseTool sharedInstance] purchaseWithProductID:productID orderNo:result success:^{
//                [weakself dismissViewControllerAfterShowMessage];
//            } failure:^{
//                [weakself dismissViewControllerAfterShowMessage];
//            }];
        }
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
    }];
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo {
    [NetworkTool payForTrendsToMiddleAccountWithOrderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [self dismissViewControllerAfterShowMessage];
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
        [weakself dismissViewController];
    });
}

#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    } else if (section == 0) {
        return self.inputArray.count + 1;
    } else {
        return self.payTypeArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakself = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            OrderMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_Message forIndexPath:indexPath];
            cell.textViewDidEndEdit = ^(NSString *text) {
                weakself.inputMessage = text;
            };
            return cell;
        } else {
            OrderInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_OrderInput forIndexPath:indexPath];
            cell.index = indexPath.row;
            cell.dict = self.inputArray[indexPath.row];
            
            cell.textFieldDidEndEdit = ^(NSString *text, NSUInteger index) {
                if (index == 0) {
                    weakself.inputTelNum = text;
                } else if (index == 1)  {
                    weakself.inputEmail = text;
                }
            };
            return cell;
        }
    } else if (indexPath.section == 1) {
        CrowdfundingInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_CrowdInfo forIndexPath:indexPath];
        
        // Configure the cell...
        cell.homeFocusModel = _homeFocusModel;
        return cell;
    } else {
        PayTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_PayType forIndexPath:indexPath];
        
        cell.index = indexPath.row;
        cell.isSelected = (_currentPayIndex == indexPath.row);
        cell.dict = self.payTypeArray[indexPath.row];
        __weak typeof(self) weakself = self;
        cell.selectPayType = ^(NSUInteger index) {
            weakself.currentPayIndex = index;
            [weakself.tableView reloadData];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CGFloat cellH = 8;
        cellH += [NSString heightWithString:_homeFocusModel.goodsName
                                    maxSize:CGSizeMake(WIDTH - 145, 0)
                                    strFont:[UIFont systemFontOfSize:17]];
        cellH += 8;
        
        cellH += [NSString heightWithString:_homeFocusModel.instro
                                    maxSize:CGSizeMake(WIDTH - 145, 0)
                                    strFont:[UIFont systemFontOfSize:13]];
        cellH += 8;
        if (cellH < 130) {
            cellH = 130;
        }
        return cellH;
    } else if (indexPath.section == 2) {
        return 58;
    } else {
        if (indexPath.row == 2) {
            return 153;
        } else {
            return 48;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
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

//
//  OfficiallyCertifiedViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/6.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "OfficiallyCertifiedViewController.h"
#import "SetCertifiedInfoViewController.h"
#import "ProductPhotoViewCell.h"
#import <JKCountDownButton.h>
#import "UserBaseInfoModel.h"
#import "AlertViewTool.h"
#import "TakePhotoHelp.h"
#import "UserDefaultsTool.h"

@interface OfficiallyCertifiedViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *certifiedInfoTextField;

@property (weak, nonatomic) IBOutlet UITextField *zfbAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *zfbRealNameTextField;

@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic,   copy) NSString *authCode;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic, strong) NSNumber *certifiedType;

@end

static NSString * const collectionViewCellID_Photo  = @"ProductPhotoViewCell";

@implementation OfficiallyCertifiedViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray new];
        [_photoArray addObject:[UIImage imageNamed:@"发布-添加"]];
    }
    return _photoArray;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"官方认证";
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(popViewController)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UICollectionViewFlowLayout *flowLaout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLaout.minimumLineSpacing = 3;
    flowLaout.minimumInteritemSpacing = 3;
    flowLaout.sectionInset = UIEdgeInsetsMake(0, 12, 12, 9);
    CGFloat itemW = (WIDTH - 27) / 3;
    flowLaout.itemSize = CGSizeMake(itemW, itemW);
    
    _phoneNumTextField.text = [[LoginData sharedLoginData].hxu substringFromIndex:2];
    
    __weak typeof(self) weakself = self;
    [_getCodeButton countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        NSString *phoneNum = _phoneNumTextField.text;
        if (phoneNum.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        } else {
            [NetworkTool getVerifyCodeForOfficiallyCertifiedWithPhoneNumber:phoneNum success:^(id Result) {
                weakself.authCode = Result;
            } failure:nil];
            
            [sender startCountDownWithSecond:60];
        }
    }];
    
    [_getCodeButton countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"验证(%zd)",second];
        return title;
    }];
    
    [_getCodeButton countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return @"验证";
    }];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
}

- (void)popViewController {
    if (_present) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window) {// 是否是正在使用的视图
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

- (IBAction)submitCertifiedButtonClicked:(UIButton *)sender {
    if (!sender.isSelected) {
        return;
    }
    
    if (![_zfbAccountTextField.text isEqualToString:_confirmAccountTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入支付宝账号不一致"];
        return;
    }

    NSString *authCode = _authCodeTextField.text;
    if (![_authCode isEqualToString:authCode]) {
        [SVProgressHUD showInfoWithStatus:@"验证码不正确"];
        return;
    }
    
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSUInteger i = 0 ; i < self.photoArray.count - 1; i++) {
        UIImage *image = self.photoArray[i];
        [muArray addObject:UIImageJPEGRepresentation(image,0.8)];
    }
    
    __weak typeof(self) weakself = self;
    [NetworkTool uploadImages:muArray progress:^(CGFloat percent) {
        [SVProgressHUD showProgress:percent status:@"上传图片"];
    } success:^(NSArray *urlArray) {
        [SVProgressHUD dismiss];
        NSMutableString *urlString = [NSMutableString string];
        for (NSString *url in urlArray) {
            [urlString appendString:url];
            [urlString appendString:@";"];
        }
        NSUInteger maxRange = NSMaxRange([urlString rangeOfComposedCharacterSequenceAtIndex:urlString.length - 2]);
        weakself.imageUrl = [urlString substringToIndex:maxRange];
        
        [SVProgressHUD showWithStatus:@"正在提交"];
        [NetworkTool officiallyCertifiedWithAuditResult:_certifiedInfoTextField.text
                                             verifiCode:_authCode
                                                account:_zfbAccountTextField.text
                                               imageUrl:_imageUrl
                                               realName:_zfbRealNameTextField.text
                                                 mobile:_phoneNumTextField.text
                                              auditType:_certifiedType success:^{
                                                  [SVProgressHUD dismiss];
                                                  [MobClick event:@"UserAudit"];
                                                  if (weakself.userBaseInfoModel) {
                                                      weakself.userBaseInfoModel.audit = [_certifiedType intValue] == 0 ? 2 : 4;
                                                  }
                                                  [LoginData sharedLoginData].audit = [_certifiedType intValue] == 0 ? 2 : 4;
                                                  [UserDefaultsTool saveLoginData];
            [AlertViewTool showAlertViewWithTitle:nil
                                          Message:@"您的认证已提交，请耐心等待"
                                      buttonTitle:@"我知道了"
                                        sureBlock:^{
                                            [weakself popViewController];
            }];
        } failure:^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"认证提交失败"];
        }];
    } failure:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传图片失败"];
    }];
}

#pragma mark -
#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        NSUInteger count = self.photoArray.count;
        NSUInteger row = count % 3 == 0 ? (count / 3) : (count / 3 + 1);
        CGFloat cellH = row * (WIDTH - 27) / 3 + (row - 1) * 3 + 80;
        return cellH;
    } else if (indexPath.row == 7) {
        return 108;
    } else {
        return 66;
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate & DataSource 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductPhotoViewCell *cell_photo = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID_Photo forIndexPath:indexPath];
    cell_photo.photo = self.photoArray[indexPath.row];
    cell_photo.index = indexPath.row;
    cell_photo.isShowDeleteButton = (indexPath.row == (self.photoArray.count - 1));
    
    __weak typeof(self) weakself = self;
    cell_photo.deletePhotoBlock = ^(NSUInteger index) {
        [weakself.photoArray removeObjectAtIndex:index];
        [weakself.collectionView reloadData];
        [weakself.tableView reloadData];
    };
    return cell_photo;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.photoArray.count - 1) {
        __weak typeof(self) weakself = self;
        [[TakePhotoHelp sharedInstance] showActionSheetWithTitle:@"选择图片" photosCount:self.photoArray.count viewController:self returnBlock:^(BOOL isCover, NSArray<UIImage *> *photos) {
            NSArray *oldArray = weakself.photoArray;
            NSMutableArray *muArray = [NSMutableArray array];
            [muArray addObjectsFromArray:photos];
            [muArray addObjectsFromArray:oldArray];
            weakself.photoArray = muArray;
            [weakself.collectionView reloadData];
            [weakself.tableView reloadData];
            [weakself shouldSubmitButtonSelect];
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self shouldSubmitButtonSelect];
}

- (void)shouldSubmitButtonSelect {
    self.submitButton.selected = _certifiedInfoTextField.text.length &&
                                _zfbAccountTextField.text.length &&
                                _confirmAccountTextField.text.length &&
                                _phoneNumTextField.text.length &&
                                _authCodeTextField.text.length &&
                                _photoArray.count > 6;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[SetCertifiedInfoViewController class]]) {
        SetCertifiedInfoViewController *setCertifiedInfoVC = (SetCertifiedInfoViewController *)destVC;
        setCertifiedInfoVC.setCertifiedInfoBlock = ^(NSString *certifiedInfo, NSNumber *certifiedType) {
            self.certifiedInfoTextField.text = certifiedInfo;
            self.certifiedType = certifiedType;
        };
    }
}

@end

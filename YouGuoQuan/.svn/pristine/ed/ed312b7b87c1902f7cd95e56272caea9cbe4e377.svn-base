//
//  SetCountViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/14.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "SetCountViewController.h"
#import <Masonry.h>
#import "VerifyCodeViewController.h"

@interface SetCountViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telephoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordtextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation SetCountViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self confirmViewController];
}

- (void)confirmViewController {
    self.title = @"1/3设置账号和密码";
    self.navigationController.navigationBarHidden = NO;
    
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
    
    UIEdgeInsets padding = UIEdgeInsetsMake(5, 10, 5, 0);
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 36)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"+86";
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor blackColor];
    [leftView1 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(leftView1).with.insets(padding);
    }];
    
    _telephoneNumberTextField.leftView = leftView1;
    _telephoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    //[_telephoneNumberTextField becomeFirstResponder];
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 36)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码"]];
    [leftView2 addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView2).with.offset(11);
        make.top.equalTo(leftView2).with.offset(6);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    _setPasswordtextField.leftView = leftView2;
    _setPasswordtextField.leftViewMode = UITextFieldViewModeAlways;
    
    _nextStepButton.layer.cornerRadius = _nextStepButton.frame.size.width * 0.5;
    _nextStepButton.layer.masksToBounds = YES;
    
    _telephoneNumberTextField.layer.borderWidth = 1;
    _telephoneNumberTextField.layer.cornerRadius = 5;
    _telephoneNumberTextField.layer.borderColor = TextFieldBorderColor.CGColor;
    
    _setPasswordtextField.layer.borderWidth = 1;
    _setPasswordtextField.layer.cornerRadius = 5;
    _setPasswordtextField.layer.borderColor = TextFieldBorderColor.CGColor;
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _setPasswordtextField) {
        NSInteger stringLength = string.length;
        if (stringLength == 0) {
            stringLength = -1;
        }
        NSUInteger textLength = textField.text.length + stringLength;
        if (textLength > 5 && textLength < 17) {
            [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"CircleButton_enable"] forState:UIControlStateNormal];
            [self.nextStepButton setTitleColor:FontColor forState:UIControlStateNormal];
        } else {
            [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"CircleButton_normal"] forState:UIControlStateNormal];
            [self.nextStepButton setTitleColor:RGBA(53, 32, 7, 0.3) forState:UIControlStateNormal];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"CircleButton_normal"] forState:UIControlStateNormal];
    [self.nextStepButton setTitleColor:RGBA(53, 32, 7, 0.3) forState:UIControlStateNormal];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[VerifyCodeViewController class]]) {
        VerifyCodeViewController *verifyVC = (VerifyCodeViewController *)destVC;
        verifyVC.telephoneNumber = _telephoneNumberTextField.text;
        verifyVC.password = _setPasswordtextField.text;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    if ([identifier isEqualToString:@"RegisterToPrivacy"]) {
        return YES;
    } else {
        BOOL isSegue = FALSE;
        NSString *telephoneNumber = _telephoneNumberTextField.text;
        if (telephoneNumber.length == 0 || ![HelperUtil checkTelNumber:telephoneNumber]) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
            return isSegue;
        }
        
        NSUInteger textLength = _setPasswordtextField.text.length;
        if (textLength < 6 || textLength > 16) {
            _setPasswordtextField.layer.borderColor = NavColor.CGColor;
            NSString *showString;
            if (textLength == 0) {
                showString = @"密码不能为空";
            } else {
                showString = @"密码必须为6-16位";
            }
            [SVProgressHUD showInfoWithStatus:showString];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _setPasswordtextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            });
        } else {
            isSegue = TRUE;
        }
        return isSegue;
    }
}

@end

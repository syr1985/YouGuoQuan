//
//  VerifyCodeViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/14.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import <JKCountDownButton/JKCountDownButton.h>
#import <Masonry.h>
#import "PersonalInfoViewController.h"

@interface VerifyCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputAuthCodeTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getAuthCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (nonatomic, copy) NSString *authCode;
@end

@implementation VerifyCodeViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self confirmViewController];
}

- (void)confirmViewController {
    self.title = @"2/3验证手机号";
    
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
    
    self.currentPhoneNumberLabel.text = [NSString stringWithFormat:@"当前号码：+86 %@",_telephoneNumber];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(5, 10, 5, 0);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 36)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"验证码";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = FontColor;
    [leftView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(leftView).with.insets(padding);
    }];
    
    _inputAuthCodeTextField.leftView = leftView;
    _inputAuthCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    _inputAuthCodeTextField.layer.borderWidth = 1;
    _inputAuthCodeTextField.layer.cornerRadius = 5;
    _inputAuthCodeTextField.layer.borderColor = TextFieldBorderColor.CGColor;
    
    __weak typeof(self) weakself = self;
    [_getAuthCodeButton countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        sender.enabled = NO;
        
        [NetworkTool getMsgAuthCode:_telephoneNumber RetsetPassword:NO Result:^(NSString *code) {
            weakself.authCode = code;
        }];
        
        [sender startCountDownWithSecond:60];
        
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"重新获取验证码(%zd)",second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"重新获取验证码";
        }];
    }];
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
    if (textField == _inputAuthCodeTextField) {
        NSInteger stringLength = string.length;
        if (stringLength == 0) {
            stringLength = -1;
        }
        NSUInteger textLength = textField.text.length + stringLength;
        self.nextStepButton.enabled = textLength != 0;
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PersonalInfoViewController *personVC = segue.destinationViewController;
    personVC.telephoneNumber = _telephoneNumber;
    personVC.password = _password;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    BOOL isSegue = FALSE;
    if ([_inputAuthCodeTextField.text isEqualToString:_authCode]) {
        isSegue = TRUE;
    } else {
        [SVProgressHUD showInfoWithStatus:@"验证码错误"];
    }
    return isSegue;
}

@end
//
//  SetCeritifiedInfoViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/20.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "SetCertifiedInfoViewController.h"

@interface SetCertifiedInfoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *certifiedInfoTextField;
@property (nonatomic, strong) NSMutableArray *certifiedInfoArray;
@end

@implementation SetCertifiedInfoViewController

-(NSMutableArray *)certifiedInfoArray {
    if (!_certifiedInfoArray) {
        _certifiedInfoArray = [NSMutableArray array];
    }
    return _certifiedInfoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"官方认证";
    
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
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)certifiedTypeSelected:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        __block NSUInteger index = NSNotFound;
        [self.certifiedInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *text = (NSString *)obj;
            if ([sender.titleLabel.text isEqualToString:text]) {
                index = idx;
                *stop = YES;
            }
        }];
        if (index != NSNotFound) {
            [self.certifiedInfoArray removeObjectAtIndex:index];
            [self setTextFieldText];
        }
    } else {
        if (self.certifiedInfoArray.count < 3) {
             sender.selected = YES;
            [self.certifiedInfoArray addObject:sender.titleLabel.text];
            
            [self setTextFieldText];
        } else {
            [SVProgressHUD showInfoWithStatus:@"至多可选3个"];
        }
    }
}

- (void)setTextFieldText {
    NSMutableString *muString = [NSMutableString string];
    for (NSString *text in self.certifiedInfoArray) {
        [muString appendString:text];
        [muString appendString:@","];
    }
    self.certifiedInfoTextField.text = muString;
}

- (IBAction)submitPersonalCertified:(id)sender {
    [self submitCertifiedInfo:@(2)];
}

- (IBAction)submitTeamCertified:(id)sender {
    [self submitCertifiedInfo:@(4)];
}

- (void)submitCertifiedInfo:(NSNumber *)certifiedType {
    if (!_certifiedInfoTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入认证信息"];
        return;
    }
    if (_setCertifiedInfoBlock) {
        NSString *certifiedInfo = [_certifiedInfoTextField.text substringToIndex:_certifiedInfoTextField.text.length - 1];
        _setCertifiedInfoBlock(certifiedInfo, certifiedType);
    }
    [self popViewController];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length) {
        if ([textField.text containsString:@","]) {
            NSArray *textArray = [textField.text componentsSeparatedByString:@","];
            NSMutableArray *muTextArray = [NSMutableArray arrayWithArray:textArray];
            // 2. 去掉空字符串
            __block NSMutableArray *removeArray = [NSMutableArray array];
            [muTextArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *text = (NSString *)obj;
                if (text.length == 0) {
                    [removeArray addObject:text];
                }
            }];
            if (removeArray.count) {
                [muTextArray removeObjectsInArray:removeArray];
            }

            if (muTextArray.count < 4) {
                self.certifiedInfoArray = muTextArray;
            } else {
                NSArray *subArray = [muTextArray subarrayWithRange:NSMakeRange(0, 3)];
                self.certifiedInfoArray = [NSMutableArray arrayWithArray:subArray];
            }
        } else {
            [self.certifiedInfoArray addObject:textField.text];
        }
        
        [self setTextFieldText];
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

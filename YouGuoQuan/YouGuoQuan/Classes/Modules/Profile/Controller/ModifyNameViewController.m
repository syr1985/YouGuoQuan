//
//  ModifyNameViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/13.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ModifyNameViewController.h"

@interface ModifyNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = _name;
    NSString *ph = [NSString stringWithFormat:@"请填写%@",_name];
    if ([_name isEqualToString:@"体重"]) {
        ph = [NSString stringWithFormat:@"请填写%@，单位kg",_name];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([_name isEqualToString:@"身高"]) {
        ph = [NSString stringWithFormat:@"请填写%@，单位cm",_name];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    _textField.placeholder = ph;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(saveNewValue)];
    rightItem.tintColor = NavTabBarColor;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//我的-单项修改我的资料 mtype取值 nickName height weight work
- (void)saveNewValue {
    NSString *type = nil;
    NSString *newValue = nil;
    if ([_name isEqualToString:@"昵称"]) {
        type = @"nickName";
        newValue = _textField.text;
    } else if ([_name isEqualToString:@"职业"]) {
        type = @"work";
        newValue = _textField.text;
    } else if ([_name isEqualToString:@"身高"]) {
        type = @"height";
        newValue = [NSString stringWithFormat:@"%@cm",_textField.text];
    } else if ([_name isEqualToString:@"体重"]) {
        type = @"weight";
        newValue = [NSString stringWithFormat:@"%@kg",_textField.text];
    }
    if (!newValue.length) {
        newValue = @"未填写";
    }
    
    __weak typeof(self) weakself = self;
    [NetworkTool modifyPersonInfoWithType:type value:newValue success:^{
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"修改%@成功",_name]];
        if (weakself.saveNewValueSuccess) {
            weakself.saveNewValueSuccess(newValue, type);
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } failure:^{
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"修改%@失败",_name]];
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

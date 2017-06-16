//
//  ReportViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/1.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController () <UITextViewDelegate>
@property (weak,   nonatomic) IBOutlet UITextView *textView;
@property (weak,   nonatomic) UILabel  *placeholder;
@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation ReportViewController

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray new];
    }
    return _selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _textView.layer.borderColor = TextFieldBorderColor.CGColor;
    _textView.layer.borderWidth = 1;
    
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.text = @"来吧，大声说出你的话";
    placeholder.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    placeholder.textColor = TextViewPlaceHolderColor;
    placeholder.frame = CGRectMake(5, 5, _textView.frame.size.width - 10, 21);
    placeholder.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:placeholder];
    _placeholder = placeholder;
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

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reportButtonClicked {
    if (!self.selectArray.count) {
        [SVProgressHUD showInfoWithStatus:@"请选择举报原因"];
        return;
    }
    
    NSString *muString = [NSString string];
    for (NSString *content in self.selectArray) {
        muString = [muString stringByAppendingString:content];
        muString = [muString stringByAppendingString:@";"];
    }
    if (self.textView.text.length) {
        muString = [muString stringByAppendingString:self.textView.text];
    }
    
    [NetworkTool reportOthersWithType:@(_reportType) reason:muString aboutID:_aboutId success:^{
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];
    }];
}

- (IBAction)reportItemClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self.selectArray addObject:sender.titleLabel.text];
    } else {
        [self.selectArray removeObject:sender.titleLabel.text];
    }
}


#pragma mark - TextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if (textView.text.length > 0) {
        _placeholder.hidden = YES;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _placeholder.hidden = NO;
    } else {
        _placeholder.hidden = YES;
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

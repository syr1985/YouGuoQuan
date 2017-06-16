//
//  FeedBackViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/4.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) UILabel  *placeholder;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"意见反馈";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.text = @"您的建议是我们改进的动力！";
    placeholder.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    placeholder.textColor = [HelperUtil colorWithHexString:@"#A5A5A5"];
    placeholder.frame = CGRectMake(7, 5, _textView.frame.size.width - 14, 21);
    placeholder.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:placeholder];
    _placeholder = placeholder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)suggestButtonClicked:(id)sender {
    if (_textView.text.length != 0) {
        [NetworkTool submitFeedbackWithSuggestion:_textView.text success:^{
            [SVProgressHUD showSuccessWithStatus:@"感谢您的宝贵建议"];
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"建议意见提交失败"];
        }];
    } else {
        [SVProgressHUD showInfoWithStatus:@"请输入意见反馈"];
    }
}


#pragma mark -
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

- (void)textViewDidEndEditing:(UITextView *)textView {
    //    if (_textViewDidEndEdit) {
    //        _textViewDidEndEdit(textView.text);
    //    }
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

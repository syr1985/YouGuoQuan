//
//  EvaluationViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "EvaluationViewController.h"
#import "NSString+AttributedText.h"

@interface EvaluationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLabel;
@property (weak, nonatomic) IBOutlet UIStackView *starStackView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, assign) NSInteger starsCount;
@property (nonatomic, strong) NSArray *evaluationArray;
@property (weak,   nonatomic) UILabel *placeholder;
@end

@implementation EvaluationViewController

- (NSArray *)evaluationArray {
    if (!_evaluationArray) {
        _evaluationArray = @[@"太差劲了！",@"一般般！",@"还不错哦！",@"非常好！",@"超级棒！"];
    }
    return _evaluationArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleLabel.text = _goodsName;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.text = @"您的评价对别人很有参考价值哦！";
    placeholder.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    placeholder.textColor = TextViewPlaceHolderColor;
    placeholder.frame = CGRectMake(7, 5, _contentTextView.frame.size.width - 14, 21);
    placeholder.backgroundColor = [UIColor clearColor];
    [self.contentTextView addSubview:placeholder];
    _placeholder = placeholder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (textView.text.length > 100) {
        [SVProgressHUD showInfoWithStatus:@"评论不能超过100字"];
        return NO;
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


- (IBAction)starButtonClicked:(UIButton *)sender {
    _starsCount = sender.tag;
    for (int i = 1; i < 6; i++) {
        UIButton *btn = [_starStackView viewWithTag:i];
        btn.selected = (i <= _starsCount);
    }
    NSString *scoreString = [NSString stringWithFormat:@"%zd分",_starsCount];
    NSAttributedString *attrStr = [NSString attributedStringWithString:scoreString
                                                                  font:[UIFont systemFontOfSize:14]
                                                                 range:NSMakeRange(1, 1)];
    _scoreLabel.attributedText = attrStr;
    _evaluationLabel.text = self.evaluationArray[sender.tag - 1];
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)evaluateButtonClicked:(id)sender {
    if (_starsCount == 0) {
        [SVProgressHUD showInfoWithStatus:@"您还没有为该商品或活动进行评星"];
        return;
    }
    
    if (!_contentTextView.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入评论内容"];
        return;
    }
    
    __weak typeof(self) weakself = self;
    [NetworkTool evaluateOrderWithOrderId:_orderId goodsId:_goodsId content:_contentTextView.text stars:@(_starsCount) success:^{
        [SVProgressHUD showSuccessWithStatus:@"评价成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshTableView object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"评价失败"];
    }];
}

@end
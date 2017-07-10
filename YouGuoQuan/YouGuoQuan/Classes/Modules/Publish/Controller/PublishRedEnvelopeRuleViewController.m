//
//  PublishRedEnvelopeRuleViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/26.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "PublishRedEnvelopeRuleViewController.h"

@interface PublishRedEnvelopeRuleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PublishRedEnvelopeRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    
    NSArray *giftName = @[@"爱心",@"棒棒糖",@"玫瑰花",@"冰淇淋"];
    
    NSUInteger index = 33;
    for (NSUInteger i = 0; i < 4; i++) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"看红包照片-%@",giftName[i]]];
        attachment.bounds = CGRectMake(0, -10, 30, 30);
        NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:attachment];
        [string insertAttributedString:attrString atIndex:index];
        index += 29;
    }
    _textView.attributedText = string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)surePublishRuleButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
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

//
//  ChooseWeiXinPriceViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/22.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ChooseWeiXinPriceViewController.h"

@interface ChooseWeiXinPriceViewController ()
//@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation ChooseWeiXinPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)priceButtonClicked:(UIButton *)sender {
    sender.selected = YES;
    if (_selectPublishPriceBlock) {
        _selectPublishPriceBlock(sender.titleLabel.text, @(sender.tag));
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end

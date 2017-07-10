//
//  ChooseWeiXinPriceViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/22.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ChooseWeiXinPriceViewController.h"

@interface ChooseWeiXinPriceViewController ()

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

- (IBAction)tapBackgroundViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    UIView *tapView = sender.view;
    UIImageView *imageView = [tapView viewWithTag:1];
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = NavTabBarColor.CGColor;
    
    UILabel *titleLabel = [tapView viewWithTag:2];
    titleLabel.textColor = NavTabBarColor;
    
    UILabel *priceLabel = [tapView viewWithTag:3];
    priceLabel.textColor = NavTabBarColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if (_selectPublishPriceBlock) {
                _selectPublishPriceBlock(priceLabel.text, @(tapView.tag));
            }
        }];
    });
}


@end

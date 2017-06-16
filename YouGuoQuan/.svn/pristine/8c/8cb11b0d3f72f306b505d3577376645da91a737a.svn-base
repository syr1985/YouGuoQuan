//
//  ChooseProductPriceViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/26.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ChooseProductPriceViewController.h"

@interface ChooseProductPriceViewController ()

@end

@implementation ChooseProductPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)priceButtonClicked:(UIButton *)sender {
    //    if (![_selectButton isEqual:sender]) {
    //        sender.selected = YES;
    //        if (_selectButton) {
    //            _selectButton.selected = NO;
    //        }
    //        _selectButton = sender;
    //        if (_selectPublishPriceBlock) {
    //            _selectPublishPriceBlock(sender.titleLabel.text);
    //
    //        }
    //    }
    sender.selected = YES;
    if (_selectPublishPriceBlock) {
        _selectPublishPriceBlock(sender.titleLabel.text, @(sender.tag));
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

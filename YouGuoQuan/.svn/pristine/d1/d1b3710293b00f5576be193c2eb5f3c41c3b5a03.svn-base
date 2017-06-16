//
//  ShareViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/28.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapShareView:(UITapGestureRecognizer *)sender {
    if (_tapShareItem) {
        _tapShareItem(sender.view.tag);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked {
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

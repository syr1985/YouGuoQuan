//
//  AboutUsViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"关于我们";
    
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text =  [NSString stringWithFormat:@"尤果圈V%@",versionString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

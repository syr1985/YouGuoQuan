//
//  WithdrawCashViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/6.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "WithdrawCashViewController.h"
#import "FillInAccountViewController.h"
#import "NSDate+LXExtension.h"
#import "AlertViewTool.h"

@interface WithdrawCashViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *withdrawCashTextField;
@property (weak, nonatomic) IBOutlet UILabel *withdrawCashTipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *withcashButton;
@end

@implementation WithdrawCashViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"提现";
    
    //[self resetTipsContent];
    _withdrawCashTextField.text = [NSString stringWithFormat:@"%@",_totalIncome];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger totalMoney = [_totalIncome integerValue];
    NSString *weakday = [self weekdayStringFromDate];
    //NSLog(@"当前时间算周几：%@",weakday);
    self.withcashButton.enabled =   totalMoney >= 1000 &&
                                    ([LoginData sharedLoginData].star > 2 ||
                                     [LoginData sharedLoginData].audit == 1 ||
                                     [LoginData sharedLoginData].audit == 3 ||
                                     [LoginData sharedLoginData].isRecommend) &&
                                     [weakday isEqualToString:@"星期一"];
}

//根据日期求星期几
- (NSString *)weekdayStringFromDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destVC = segue.destinationViewController;
    FillInAccountViewController *fillAccountVC = (FillInAccountViewController *)destVC;
    fillAccountVC.totalWithCash = _withdrawCashTextField.text;
}


@end

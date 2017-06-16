//
//  BaseViewController.m
//  XieChengMLS
//
//  Created by apple on 15/5/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "NSString+StringSize.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(popViewController)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewWillAppear:(BOOL)animated {
    if (![LoginData sharedLoginData].userId) {
        [self popViewController];
    }
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    
    UIFont *titleFont = [UIFont systemFontOfSize:17];
    CGFloat titleH = 30;
    CGFloat titleW = [NSString widthWithString:titleString
                                       maxSize:CGSizeMake(0, titleH)
                                       strFont:titleFont];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.bounds = CGRectMake(0, 0, titleW, titleH);
    titleLabel.textColor = FontColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = titleFont;
    titleLabel.text = titleString;
    self.navigationItem.titleView = titleLabel;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window) {// 是否是正在使用的视图
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

@end

//
//  SCNavTabBarController.h
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NavType) {
    NavType_Normal = 0,
    NavType_Hidden = 1,
    NavType_Custom = 2,
    NavType_Order  = 3
};

extern NSString * const kNotification_ShowScreenMenu;

@class SCNavTabBar;
@interface SCNavTabBarController : UIViewController

@property (nonatomic, strong) NSArray   *subViewControllers;// An array of children view controllers

@property (nonatomic, strong) UIColor   *navTabBarColor;
@property (nonatomic, strong) UIColor   *navTabBarLineColor;

@property (nonatomic, assign) NSInteger defaultIndex;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIFont    *titleFont;
@property (nonatomic, assign) NavType   navType; //导航栏类型

@property (nonatomic, assign) BOOL      isHomeFocusPage;    // 是否是首页关注页
@property (nonatomic, assign) BOOL      showSpaceLine;      // 是否显示分割线
@property (nonatomic, assign) BOOL      setupScreenButton;  // 是否创建筛选按钮

/**
 *  Initialize SCNavTabBarViewController Instance, Show On The Parent View Controller And Show On The Parent View Controller
 *
 *  @param subControllers - set an array of children view controllers
 *  @param viewController - set parent view controller
 *
 *  @return Instance
 */
//- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController showSpaceLine:(BOOL)bShowSpaceLine;

/**
 *  Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 */
- (void)addParentController:(UIViewController *)viewController;

- (void)resetIndex;

@end


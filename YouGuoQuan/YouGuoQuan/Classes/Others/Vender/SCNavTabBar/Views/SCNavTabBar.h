//
//  SCNavTabBar.h
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCNavTabBarDelegate <NSObject>

@optional
/**
 *  When NavTabBar Item Is Pressed Call Back
 *
 *  @param index - pressed item's index
 */
- (void)itemDidSelectedWithIndex:(NSInteger)index;

/**
 *  When Arrow Pressed Will Call Back
 *
 *  @param pop    - is needed pop menu
 *  @param height - menu height
 */
- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height;

@end

@interface SCNavTabBar : UIView

@property (nonatomic, weak  ) id<SCNavTabBarDelegate> delegate;

@property (nonatomic, assign) NSInteger currentItemIndex;// current selected item's index
@property (nonatomic, strong) NSArray   *itemTitles;// all items' title
@property (nonatomic, strong) UIColor   *lineColor; // set the underscore color
@property (nonatomic, strong) UIFont    *titleFont;
@property (nonatomic, assign) BOOL      isHomeFocusPage;
@property (nonatomic, assign) BOOL      setupScreenButton;  // 是否创建筛选按钮

@property (nonatomic,   copy) void (^showLoginPage)();

/**
 *  Initialize Methods
 *
 *  @param frame    SCNavTabBar frame
 *  @param showLine show or not line of bar
 *
 *  @return Instance
 */
- (instancetype)initWithFrame:(CGRect)frame showLine:(BOOL)showLine;

- (instancetype)initWithFrame:(CGRect)frame showLine:(BOOL)showLine showSpaceLine:(BOOL)showSpaceLine;

/**
 *  Update Item Data
 */
- (void)updateData;

@end



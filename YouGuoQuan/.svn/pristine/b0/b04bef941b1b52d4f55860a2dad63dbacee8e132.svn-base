//
//  PopScreenViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/4/21.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ScreenMenuType) {
    ScreenMenuType_User = 0,
    ScreenMenuType_Income,
    ScreenMenuType_Recharge
};

@interface PopScreenMenuViewController : UITableViewController
@property (nonatomic,   copy) void (^screenMenuItemSelectedBlock)(NSInteger index);
@property (nonatomic, assign) ScreenMenuType type;

@end

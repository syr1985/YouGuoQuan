//
//  UserCenterViewController.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kNotification_LoginSuccess;

@interface UserCenterViewController : UITableViewController
@property (nonatomic,   copy) NSString *userId;
@end
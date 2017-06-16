//
//  UserCenterHeaderViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/3/30.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kNotification_PullBlackList = @"kNotification_PullBlackList";
static NSString * const kNotification_FocusOperator = @"kNotification_FocusOperator";

@class UserBaseInfoModel;
@interface UserCenterHeaderViewCell : UITableViewCell
@property (nonatomic,   copy) void (^actionSheetItemClicked)(NSUInteger buttonIndex);

@property (nonatomic,   copy) void (^shareButtonClickedBlock)();

@property (nonatomic,   copy) void (^tapHeaderImageViewBlock)(id userData);

@property (nonatomic,   copy) void (^concemButtonClickedBlock)();

@property (nonatomic,   copy) void (^funsButtonClickedBlock)();

@property (nonatomic,   copy) void (^favourButtonClickedBlock)();

@property (nonatomic,   copy) void (^contributerViewTapedBlock)();

@property (nonatomic, strong) UserBaseInfoModel *userBaseInfoModel;

@property (nonatomic, strong) NSArray *photoArray;

@property (nonatomic, strong) NSArray *contributerArray;

@property (nonatomic, assign) BOOL isMyFocus;
@end

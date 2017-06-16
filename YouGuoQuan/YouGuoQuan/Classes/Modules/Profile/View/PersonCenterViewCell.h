//
//  PersonCenterViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/3.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kNotification_ModifyImage = @"kNotification+ModifyImage";

@class UserBaseInfoModel;
@interface PersonCenterViewCell : UITableViewCell

@property (nonatomic,   copy) void (^tapHeaderImageViewBlock)();

@property (nonatomic,   copy) void (^tapBackgroundImageViewBlock)();

@property (nonatomic,   copy) void (^concemButtonClickedBlock)();

@property (nonatomic,   copy) void (^funsButtonClickedBlock)();

@property (nonatomic,   copy) void (^favourButtonClickedBlock)();

@property (nonatomic,   copy) void (^selectPhotoBlock)();

@property (nonatomic,   copy) void (^sellWeixinBlock)();

@property (nonatomic,   copy) void (^publishRedpackstBlock)();

@property (nonatomic,   copy) void (^deleteImageBlock)(NSInteger indx);

@property (nonatomic,   copy) void (^publishDeniedBlock)();

@property (nonatomic, strong) UserBaseInfoModel *userBaseInfoModel;

@property (nonatomic, strong) NSArray *photoArray;

@end

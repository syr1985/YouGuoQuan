//
//  UserCenterProductViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserCenterModel;
@interface UserCenterProductViewCell : UITableViewCell
@property (nonatomic,   copy) void (^buyButtonClickedBlock)(UserCenterModel *userCenterModel);
@property (nonatomic,   copy) void (^actionSheetItemClicked)(NSUInteger buttonIndex, NSString *trendsId, int goodsType, NSIndexPath *indexPath);
@property (nonatomic, strong) UserCenterModel *userCenterModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

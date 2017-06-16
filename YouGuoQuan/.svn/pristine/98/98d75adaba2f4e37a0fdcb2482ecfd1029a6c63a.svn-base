//
//  FocusProductViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeFocusModel;
@interface FocusProductViewCell : UITableViewCell
@property (nonatomic,   copy) void (^tapHeaderView)(NSString *userId);
@property (nonatomic,   copy) void (^actionSheetItemClicked)(NSUInteger buttonIndex, NSString *userId, NSString *focusId);
@property (nonatomic,   copy) void (^buyButtonClickedBlock)(HomeFocusModel *homeFocusModel);
@property (nonatomic,   copy) void (^handleTrendsBlock)(NSUInteger buttonIndex, NSString *focusId, NSInteger row);
@property (nonatomic, strong) HomeFocusModel *homeFocusModel;
@property (nonatomic, assign) NSInteger row;
@end

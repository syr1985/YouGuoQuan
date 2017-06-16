//
//  FocusRedEnvelopeViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kCommentSuccessNotification;
extern NSString * const kUserCenterBuyPhotoSuccessNotification;
extern NSString * const kFavourSuccessNotification;

@class HomeFocusModel;
@interface FocusRedEnvelopeViewCell : UITableViewCell
@property (nonatomic,   copy) void (^favourResultBlock)(BOOL cancel);
@property (nonatomic,   copy) void (^tapHeaderView)(NSString *userId);
@property (nonatomic,   copy) void (^commentBlock)(HomeFocusModel *model);
@property (nonatomic,   copy) void (^actionSheetItemClicked)(NSUInteger buttonIndex, NSString *userId, NSString *focusId);
@property (nonatomic,   copy) void (^buyRedPacketBlock)(NSInteger price,NSString *goodsId, NSString *feedsId, NSString *headImg, NSString *nickName);
@property (nonatomic,   copy) void (^handleTrendsBlock)(NSUInteger buttonIndex, NSString *focusId, NSInteger row);
@property (nonatomic, strong) HomeFocusModel *homeFocusModel;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) BOOL isTrendsDetail;
@end

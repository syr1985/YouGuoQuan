//
//  RecentSessionCell.h
//  YouGuoQuan
//
//  Created by liushuai on 16/12/8.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const Key_Conversation_Ext;
extern NSString * const Flag_Snap;
extern NSString * const Flag_Redpacket;

@class EMConversation;
@interface RecentSessionCell : UITableViewCell
@property (nonatomic, strong) EMConversation *conversationModel;
@end
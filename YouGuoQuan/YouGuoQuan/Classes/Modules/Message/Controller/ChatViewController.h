//
//  ChatViewController.h
//  YouGuoQuan
//
//  Created by liushuai on 2016/12/16.
//  Copyright © 2016年 NT. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BaseViewController.h"

extern NSString * const Key_Conversation_Ext;
extern NSString * const Flag_Snap;
extern NSString * const Flag_Redpacket;

@class EMConversation;
@interface ChatViewController : BaseViewController

- (instancetype)initWithConversationChatter:(NSString *)conversationId
                                   userInfo:(NSDictionary *)target;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end

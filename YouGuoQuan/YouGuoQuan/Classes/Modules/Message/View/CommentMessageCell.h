//
//  CommentMessageCell.h
//  YouGuoQuan
//
//  Created by liushuai on 16/12/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentMessageModel;
@interface CommentMessageCell : UITableViewCell
@property (nonatomic,   copy) void (^tapHeaderImageViewBlock)(NSString *userId);
@property (nonatomic, strong) CommentMessageModel *commentMessageModel;
@end
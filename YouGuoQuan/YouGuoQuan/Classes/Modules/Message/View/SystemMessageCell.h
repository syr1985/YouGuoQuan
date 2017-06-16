//
//  SystemMessageCellTableViewCell.h
//  YouGuoQuan
//
//  Created by liushuai on 16/12/9.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemMessageModel;
@interface SystemMessageCell : UITableViewCell
@property (nonatomic,   copy) void (^tapUserNickNameBlock)(NSString *userId);
@property (nonatomic, strong) SystemMessageModel *systemMessageModel;
@end

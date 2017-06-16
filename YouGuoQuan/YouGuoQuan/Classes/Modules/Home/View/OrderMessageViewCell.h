//
//  OrderMesageViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/29.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMessageViewCell : UITableViewCell
@property (nonatomic,   copy) void (^textViewDidEndEdit)(NSString *text);
@end

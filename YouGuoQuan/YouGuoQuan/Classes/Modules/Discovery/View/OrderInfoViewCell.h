//
//  OrderInfoViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/30.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoViewCell : UITableViewCell
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic,   copy) NSString *price;
@property (nonatomic,   copy) void (^textFieldDidEndEdit)(NSString *text, NSUInteger index);
@end

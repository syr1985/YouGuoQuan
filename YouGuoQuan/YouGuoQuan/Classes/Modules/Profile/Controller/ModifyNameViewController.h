//
//  ModifyNameViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/13.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyNameViewController : BaseViewController
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) void (^saveNewValueSuccess)(NSString *newValue, NSString *key);
@end

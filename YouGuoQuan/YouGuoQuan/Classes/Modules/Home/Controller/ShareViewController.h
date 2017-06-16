//
//  ShareViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/4/28.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController

@property (nonatomic,   copy) void (^tapShareItem)(NSInteger index);

@end

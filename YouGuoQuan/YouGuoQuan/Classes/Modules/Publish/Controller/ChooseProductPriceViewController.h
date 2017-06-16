//
//  ChooseProductPriceViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/4/26.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseProductPriceViewController : UIViewController
@property (nonatomic,   copy) void (^selectPublishPriceBlock)(NSString *text, NSNumber *price);
@end

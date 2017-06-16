//
//  ActionSheetHelp.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/25.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionSheetHelp : NSObject

@property (nonatomic,   copy) void (^actionSheetItemClicked)(NSString *title, NSUInteger buttonIndex);

+ (instancetype)sharedInstance;

@end

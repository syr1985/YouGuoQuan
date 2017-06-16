//
//  NSString+emoji.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/14.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (emoji)

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSString *)convertStringContainsEmoji:(NSString *)string;

@end

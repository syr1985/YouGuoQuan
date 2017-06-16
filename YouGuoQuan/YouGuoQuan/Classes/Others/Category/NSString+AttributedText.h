//
//  NSString+AttributedText.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/20.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedText)
+ (NSAttributedString *)attributedStringWithString:(NSString *)str font:(UIFont *)font range:(NSRange)range;

+ (NSAttributedString *)attributedStringWithString:(NSString *)str color:(UIColor *)color range:(NSRange)range;
@end

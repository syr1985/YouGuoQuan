//
//  NSString+StringSize.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/7.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)

+ (CGFloat)heightWithString:(NSString *)str maxSize:(CGSize)maxSize strFont:(UIFont *)font {
    if (!str || str.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attr = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect rect = [str boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attr
                                    context:nil];
    return rect.size.height;
}

+ (CGFloat)widthWithString:(NSString *)str maxSize:(CGSize)maxSize strFont:(UIFont *)font {
    if (!str || str.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attr = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect rect = [str boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attr
                                    context:nil];
    return rect.size.width;
}

@end

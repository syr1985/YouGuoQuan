//
//  NSString+ImageCompress.h
//  YouGuoQuan
//
//  Created by YM on 2017/3/20.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ImageCompress)
+ (NSString *)compressImageUrlWithUrlString:(NSString *)imageUrl width:(CGFloat)imageW height:(CGFloat)imageH;

+ (NSString *)cropImageUrlWithUrlString:(NSString *)imageUrl width:(CGFloat)imageW height:(CGFloat)imageH;

+ (NSString *)imageUrlWithWatermark:(NSString *)urlString;
@end

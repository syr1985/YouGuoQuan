//
//  UIImage+Color.m
//  网易彩票2014MJ版
//
//  Created by 沐汐 on 14-9-13.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)


//给我一种颜色，一个尺寸，我给你返回一个UIImage
+(UIImage *)imageFromContextWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect=(CGRect){{0.0f,0.0f},size};
    
    //开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    
    //获取图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    //获取图像
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)imageFromContextWithColor:(UIColor *)color {
    
    CGSize size = CGSizeMake(1.0f, 1.0f);
    
    return [self imageFromContextWithColor:color size:size];
}

+ (UIImage *)imageWithUIView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSData *)compressImage {
    //实现等比例缩放
    CGFloat hfactor = self.size.width / WIDTH;
    CGFloat vfactor = self.size.height / HEIGHT;
    CGFloat factor = fmax(hfactor, vfactor);
    //画布大小
    CGFloat newWith = self.size.width / factor;
    CGFloat newHeight = self.size.height / factor;
    CGSize newSize = CGSizeMake(newWith, newHeight);
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newWith, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //图像压缩
    NSData *newImageData = UIImageJPEGRepresentation(newImage, 0.5);
    return newImageData;
}
@end

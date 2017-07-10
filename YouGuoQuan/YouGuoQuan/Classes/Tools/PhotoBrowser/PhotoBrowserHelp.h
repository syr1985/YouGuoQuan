//
//  PhotoBrowserHelp.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/5.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoBrowserHelp : NSObject

+ (void)openPhotoBrowserWithImages:(NSArray *)imageUrlArray sourceImageView:(UIImageView *)imageView;

+ (void)openPhotoBrowserWithImageArray:(NSArray *)imageArray sourceImageView:(UIImageView *)imageView;

+ (void)openPhotoBrowserWithImages:(NSArray *)imageUrlArray sourceImageView:(UIImageView *)imageView canDeleteImage:(BOOL)canDelete;

@end

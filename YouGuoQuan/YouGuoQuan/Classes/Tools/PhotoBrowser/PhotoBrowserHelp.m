//
//  PhotoBrowserHelp.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/5.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PhotoBrowserHelp.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Color.h"
#import "NSString+ImageCompress.h"

@interface PhotoBrowserHelp ()
@property (nonatomic, strong) UIImage *currentImage;
@end

@implementation PhotoBrowserHelp

+ (void)openPhotoBrowserWithImages:(NSArray *)imageUrlArray sourceImageView:(UIImageView *)imageView {
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray array];
    for (NSString *imgUrl in imageUrlArray) {
        NSString *urlString = [NSString imageUrlWithWatermark:imgUrl];
        //NSLog(@"%@",urlString);
        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        
        mjphoto.srcImageView = imageView; // 来源于哪个UIImageView
        mjphoto.url = [NSURL URLWithString:urlString]; // 图片路径
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = imageView.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    [browser show];
}

+ (void)openPhotoBrowserWithImageArray:(NSArray *)imageArray sourceImageView:(UIImageView *)imageView {
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray array];
    for (UIImage *image in imageArray) {
        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.image = image;
        mjphoto.srcImageView = imageView;
        
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    [browser show];
}

+ (void)openPhotoBrowserWithImages:(NSArray *)imageUrlArray sourceImageView:(UIImageView *)imageView canDeleteImage:(BOOL)canDelete {
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray array];
    for (NSString *imgUrl in imageUrlArray) {
        NSString *urlString = [NSString stringWithFormat:@"%@?imageslim",imgUrl];
        
        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.srcImageView = imageView; // 来源于哪个UIImageView
        mjphoto.url = [NSURL URLWithString:urlString]; // 图片路径
        
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = imageView.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    browser.canDeleteImage = canDelete;
    [browser show];
}


@end

//
//  TakePhotoHelp.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakePhotoHelp : NSObject

@property (nonatomic,   copy) void (^selectedPhotosReturnBlock)(BOOL isCover, NSArray<UIImage *> *photos);

+ (instancetype)sharedInstance;

- (void)showActionSheetWithTitle:(NSString *)title viewController:(UIViewController *)vc returnBlock:(void (^)(BOOL isCover, NSArray<UIImage *> *photos))result;

- (void)showActionSheetWithTitle:(NSString *)title photosCount:(NSInteger)count viewController:(UIViewController *)vc returnBlock:(void (^)(BOOL isCover, NSArray<UIImage *> *photos))result;

@end

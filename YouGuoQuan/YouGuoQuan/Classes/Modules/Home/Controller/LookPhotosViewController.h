//
//  LookPhotosViewController.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/4.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kUserCenterBuyPhotoSuccessNotification;

@interface LookPhotosViewController : UIViewController
@property (nonatomic, strong) UIImage   *backgroundImage;
@property (nonatomic,   copy) NSString  *headImg;
@property (nonatomic,   copy) NSString  *nickName;
@property (nonatomic,   copy) NSString  *goodsId;
@property (nonatomic,   copy) NSString  *feedsId;
@property (nonatomic, assign) NSInteger price;
@end

//
//  IndexBannerSubiew.h
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.

#import <UIKit/UIKit.h>

@class HomeBannerModel;

@interface IndexBannerSubiew : UIView
/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;
/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;
/**
 *  模型
 */
@property (nonatomic, strong) HomeBannerModel *homeBannerModel;
/**
 *  创建对象
 *
 *  @param frame    frame
 *  @param isNormal 是否是普通frame
 *
 *  @return 对象实例
 */
- (instancetype)initWithFrame:(CGRect)frame normal:(BOOL)isNormal;

@end

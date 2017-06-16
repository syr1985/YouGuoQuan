/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>

typedef enum{
    EMChatToolbarTypeChat,
    EMChatToolbarTypeGroup,
}EMChatToolbarType;

@protocol EaseChatBarMoreViewDelegate;
@interface EaseChatBarMoreView : UIView

@property (nonatomic,assign) id<EaseChatBarMoreViewDelegate> delegate;

@property (nonatomic) UIColor *moreViewBackgroundColor UI_APPEARANCE_SELECTOR;  //moreview背景颜色,default whiteColor

/*
 
 */
- (instancetype)initWithFrame:(CGRect)frame type:(EMChatToolbarType)type;

/*!
 @method
 @brief 新增一个新的功能按钮
 @param image 按钮图片
 @param highLightedImage 高亮图片
 @param title 按钮标题
 */
- (void)insertItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title;

/*!
 @method
 @brief 修改功能按钮图片
 @param image 按钮图片
 @param highLightedImage 高亮图片
 @param title 按钮标题
 @param index 按钮索引
 */
- (void)updateItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title
                    atIndex:(NSInteger)index;

/*!
 @method
 @brief 根据索引删除功能按钮
 @param index 按钮索引
 */
- (void)removeItematIndex:(NSInteger)index;

@end

@protocol EaseChatBarMoreViewDelegate <NSObject>

@optional

/*!
 @method
 @brief 拍照
 @param moreView 功能view
 */
- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView;

/*!
 @method
 @brief 相册
 @param moreView 功能view
 */
- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView;

/*!
 @method
 @brief 发送位置
 @param moreView 功能view
 */
- (void)moreViewLocationAction:(EaseChatBarMoreView *)moreView;

/*!
 @method
 @brief 拨打实时语音
 @param moreView 功能view
 */
- (void)moreViewAudioCallAction:(EaseChatBarMoreView *)moreView;

/*!
 @method
 @brief 拨打实时通话
 @param moreView 功能view
 */
- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView;

/*!
 @method
 @brief 自定义功能
 @param moreView    功能view
 @param index       按钮索引
 */
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index;

@end

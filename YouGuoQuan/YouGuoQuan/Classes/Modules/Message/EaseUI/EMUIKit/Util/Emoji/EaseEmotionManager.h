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

#import <Foundation/Foundation.h>
#import "EaseLocalDefine.h"
#import "EaseEmotion.h"


@interface EaseEmotionManager : NSObject

@property (nonatomic, strong) NSArray *emotions;

/*!
 @property
 @brief number of lines of emotion
 */
@property (nonatomic, assign) NSInteger emotionRow;

/*!
 @property
 @brief number of columns of emotion
 */
@property (nonatomic, assign) NSInteger emotionCol;

/*!
 @property
 @brief emotion type
 */
@property (nonatomic, assign) EMEmotionType emotionType;

@property (nonatomic, strong) UIImage *tagImage;

- (id)initWithType:(EMEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions;

- (id)initWithType:(EMEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage;

@end


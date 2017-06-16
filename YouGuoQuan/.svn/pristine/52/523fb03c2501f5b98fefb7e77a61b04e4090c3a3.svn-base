//
//  EaseEmotion.h
//  YouGuoQuan
//
//  Created by YM on 2017/2/10.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, EMEmotionType) {
    EMEmotionDefault = 0,
    EMEmotionPng,
    EMEmotionGif
};

@interface EaseEmotion : NSObject

@property (nonatomic, assign) EMEmotionType emotionType;

@property (nonatomic, copy) NSString *emotionTitle;

@property (nonatomic, copy) NSString *emotionId;

@property (nonatomic, copy) NSString *emotionThumbnail;

@property (nonatomic, copy) NSString *emotionOriginal;

@property (nonatomic, copy) NSString *emotionOriginalURL;

- (id)initWithName:(NSString*)emotionTitle
         emotionId:(NSString*)emotionId
  emotionThumbnail:(NSString*)emotionThumbnail
   emotionOriginal:(NSString*)emotionOriginal
emotionOriginalURL:(NSString*)emotionOriginalURL
       emotionType:(EMEmotionType)emotionType;

@end


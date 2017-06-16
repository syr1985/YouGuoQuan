//
//  FaceButton.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceButton.h"
#import "FaceSubjectModel.h"
#import "NSString+ZMLEmoji.h"

// 从Resourse.bundle中取出图片
#define ZMLKeyboardBundleImage(name) [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",@"Resourse.bundle/images/",name]]

@implementation FaceButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    self.adjustsImageWhenHighlighted = NO;
}

- (void)setEmotion:(FaceModel *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) { // 有图片
        [self setImage:ZMLKeyboardBundleImage(emotion.png) forState:UIControlStateNormal];
    } else if (emotion.code) { // 是emoji表情
        // 设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}

@end

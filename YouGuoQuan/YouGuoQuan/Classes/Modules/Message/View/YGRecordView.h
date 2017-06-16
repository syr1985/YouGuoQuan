//
//  YGRecordView.h
//  YouGuoQuan
//
//  Created by liushuai on 2016/12/18.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGRecordView;
@protocol YGRecordViewDelegate <NSObject>

- (void) didStartRecordingVoice: (YGRecordView *) recordView;

- (void) didCancelRecordingVoice: (YGRecordView *) recordView;

- (void) didFinishRecoingVoice : (YGRecordView *) recordView;

@end


@interface YGRecordView : UIView


@property(nonatomic, weak) id<YGRecordViewDelegate> delegate;

+(CGFloat) viewHeight;

@end

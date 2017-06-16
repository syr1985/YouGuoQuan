//
//  YGSelectPicView.h
//  YouGuoQuan
//
//  Created by liushuai on 2016/12/19.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YGSelectPicView;
@class TZAlbumModel;
@protocol YGSelectPicViewDelegate <NSObject>

- (void) didTapAlbum : (YGSelectPicView *) selectPicView;
- (void) didSendPic : (YGSelectPicView *) selectPicView;
- (void) previewPic : (YGSelectPicView *) selectPicView atIndex : (NSInteger) index;


@end

@interface YGSelectPicView : UIView

@property(nonatomic, strong, readonly) TZAlbumModel *albumModel;

@property(nonatomic, strong) NSMutableArray *selectModels;

@property(nonatomic, weak) id<YGSelectPicViewDelegate> delegate;

@property(nonatomic, readonly) BOOL shouldSendOriginPhoto;

- (void) reloadData;

- (void) reset;

+ (CGFloat) viewHeight;

@end

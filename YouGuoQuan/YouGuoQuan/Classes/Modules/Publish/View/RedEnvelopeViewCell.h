//
//  RedEnvelopeViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedEnvelopeViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign, setter=setDeleteButton:) BOOL isShowDeleteButton;
@property (nonatomic, assign, setter=setBlurEffectView:) BOOL isHiddenBlurView;
@property (nonatomic,   copy) void (^deletePhotoBlock)(NSUInteger index);

@end

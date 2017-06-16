//
//  RedEnvelopeViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "RedEnvelopeViewCell.h"
//#import "UIImage+LXExtension.h"

@interface RedEnvelopeViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blurView;
@property (weak, nonatomic) IBOutlet UIButton *deletePhotoButton;

@end

@implementation RedEnvelopeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _blurView.hidden = YES;
}

- (IBAction)deletePhoto {
    if (_deletePhotoBlock) {
        _deletePhotoBlock(_index);
    }
}

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    
    //_blurView.image = [photo blurImageWithRadius:_photoImageView.bounds.size.width * 0.5];
    
    _photoImageView.image = photo;
}

- (void)setDeleteButton:(BOOL)isShowDeleteButton {
    _isShowDeleteButton = isShowDeleteButton;
    
    _deletePhotoButton.hidden = isShowDeleteButton;
}

- (void)setBlurEffectView:(BOOL)isHiddenBlurView {
    _isHiddenBlurView = isHiddenBlurView;
    
    _blurView.hidden = isHiddenBlurView;
}

@end

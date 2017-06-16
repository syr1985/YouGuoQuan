//
//  ProductPhotoViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/24.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ProductPhotoViewCell.h"

@interface ProductPhotoViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *deletePhotosButton;

@end

@implementation ProductPhotoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)deletePhoto {
    if (_deletePhotoBlock) {
        _deletePhotoBlock(_index);
    }
}

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    
    _productPhotoImageView.image = photo;
}

- (void)setDeleteButton:(BOOL)isShowDeleteButton {
    _isShowDeleteButton = isShowDeleteButton;
    
    _deletePhotosButton.hidden = isShowDeleteButton;
}


@end

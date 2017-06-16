//
//  PublishProductFooterView.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/24.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PublishProductFooterView.h"

@interface PublishProductFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *singleSelectButton;
@property (weak, nonatomic) IBOutlet UILabel  *uploadImageSizeLabel;

@end

@implementation PublishProductFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 *  改变按钮的状态
 */
- (IBAction)singleSelectButtonClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (_setUploadOrignalPhoto) {
        _setUploadOrignalPhoto(sender.isSelected);
    }
}

- (void)setPhotosSize:(NSString *)photosSize {
    if (photosSize) {
        _photosSize = photosSize;
        
        self.uploadImageSizeLabel.text = [NSString stringWithFormat:@"（%@）",photosSize];
    }
}

@end

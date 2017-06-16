//
//  YGSelectPicCell.m
//  YouGuoQuan
//
//  Created by liushuai on 2016/12/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "YGSelectPicCell.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"
#import "Masonry.h"

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

@interface YGSelectPicCell () {
    
}
@property(nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *selectMarkBtn;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;
@property(nonatomic, strong) TZAssetModel *model;
@end


@implementation YGSelectPicCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectMarkBtn];
        [self addAutoLayConstraint];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(anctionTapImage)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}


- (void) addAutoLayConstraint {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    
    [self.selectMarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-5);
    }];
}

- (UIImageView *) imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIButton *) selectMarkBtn {
    if (!_selectMarkBtn) {
        _selectMarkBtn = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"图片选中"];
        [_selectMarkBtn setImage:[UIImage imageNamed:@"图片选择框"] forState:UIControlStateNormal];
        [_selectMarkBtn setImage:image forState:UIControlStateHighlighted];
        [_selectMarkBtn setImage:image forState:UIControlStateSelected];
        [_selectMarkBtn addTarget:self action:@selector(actionTapSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectMarkBtn;
}

- (void) refreshContent : (TZAssetModel *) model {
    self.model = model;
    
    if (iOS8Later) {
        self.representedAssetIdentifier = [[TZImageManager manager] getAssetIdentifier:model.asset];
    }
    PHImageRequestID imageRequestID = [[TZImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        // Set the cell's thumbnail image if it's still showing the same asset.
        if (!iOS8Later) {
            self.imageView.image = photo;
            return;
        }
        if ([self.representedAssetIdentifier isEqualToString:[[TZImageManager manager] getAssetIdentifier:model.asset]]) {
            self.imageView.image = photo;
        } else {
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    }];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
    
    self.selectMarkBtn.selected = model.isSelected;
}


- (void) actionTapSelectBtn {
    if (self.selectMarkBtn.selected) {
        self.selectMarkBtn.selected = NO;
    } else {
        self.selectMarkBtn.selected = YES;
    }
    self.model.isSelected = self.selectMarkBtn.selected;
    if ([self.delegate respondsToSelector:@selector(switchSelected:forCell:)]) {
        [self.delegate switchSelected:self.model.isSelected forCell:self] ;
    }
}

- (void) anctionTapImage {
    if ([self.delegate respondsToSelector:@selector(tapCell:)]) {
        [self.delegate tapCell:self];
    }
    
}

+ (NSString *) reuseIdentifier {
    return @"YGSelectPicCell";
}

@end

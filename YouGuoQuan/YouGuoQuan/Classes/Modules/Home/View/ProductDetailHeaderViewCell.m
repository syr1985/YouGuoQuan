//
//  ProductDetailHeaderViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/17.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ProductDetailHeaderViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductDetailModel.h"
//#import "NSString+AttributedText.h"
#import "UIImage+Color.h"

@interface ProductDetailHeaderViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productIntroLabel;

@end

@implementation ProductDetailHeaderViewCell

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProductDetailModel:(ProductDetailModel *)productDetailModel {
    _productDetailModel = productDetailModel;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_productImageView.frame.size];
    NSString *imageUrlStr = [NSString cropImageUrlWithUrlString:productDetailModel.imageUrl
                                                          width:_productImageView.bounds.size.width
                                                         height:_productImageView.bounds.size.height];
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                         placeholderImage:phImage];
    _productNameLabel.text = productDetailModel.goodsName;
    NSString *productPrice = [NSString stringWithFormat:@"%@ u币",productDetailModel.price];
    _productPriceLabel.text = productPrice;
//    _productPriceLabel.attributedText = [NSString attributedStringWithString:productPrice
//                                                                        font:[UIFont systemFontOfSize:14]
//                                                                       range:NSMakeRange(0, 1)];
    _productIntroLabel.text = productDetailModel.goodsInstro;
}

@end
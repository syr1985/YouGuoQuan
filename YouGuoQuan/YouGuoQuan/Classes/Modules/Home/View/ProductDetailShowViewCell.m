//
//  ProductDetailShowViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/17.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ProductDetailShowViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Color.h"

@interface ProductDetailShowViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@end

@implementation ProductDetailShowViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsUrl:(NSString *)goodsUrl {
    _goodsUrl = goodsUrl;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_productImageView.frame.size];
    NSString *imageUrlStr = [NSString cropImageUrlWithUrlString:goodsUrl
                                                          width:_productImageView.bounds.size.width
                                                         height:_productImageView.bounds.size.height];
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                         placeholderImage:phImage];
}

@end

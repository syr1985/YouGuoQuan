//
//  ProductEvaluateViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/22.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "ProductEvaluateViewCell.h"
#import "ProductEvaluateModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+LXExtension.h"

@interface ProductEvaluateViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIStackView *praiseRatingStackView;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateTimeLabel;
@end

@implementation ProductEvaluateViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headerImageView.layer.cornerRadius = 20;
    self.headerImageView.layer.masksToBounds = YES;
}

-(void)setProductEvaluateModel:(ProductEvaluateModel *)productEvaluateModel {
    _productEvaluateModel = productEvaluateModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:productEvaluateModel.headImg
                                                                  width:self.headerImageView.bounds.size.width
                                                                 height:self.headerImageView.bounds.size.height];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                            placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    self.nickNameLabel.text = productEvaluateModel.nickName;

    self.levelImageView.hidden = productEvaluateModel.star == 0;
    if (productEvaluateModel.star != 0) {
        self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d", productEvaluateModel.star]];
    }
    
    for (int i = 1; i < productEvaluateModel.stars + 1; i++) {
        UIButton *btn = [self.praiseRatingStackView viewWithTag:i];
        btn.selected = YES;
    }
    self.commentContentLabel.text = productEvaluateModel.content;
    NSTimeInterval timeInterval = [productEvaluateModel.createTime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    LXDateItem *item = [[NSDate date] lx_timeIntervalSinceDate:createDate];
    self.evaluateTimeLabel.text = [NSString stringWithFormat:@"%@前",item.description];
}

@end
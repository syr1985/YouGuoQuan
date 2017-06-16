//
//  FavorerListViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/16.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "FavorerListViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FavorerListViewCell ()
@property (weak, nonatomic) IBOutlet UIScrollView *favorersScrollView;
@end

@implementation FavorerListViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFavorerArray:(NSArray *)favorerArray {
    _favorerArray = favorerArray;
    
    for (UIView *view in _favorersScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat headImageViewS = 8;
    CGFloat headImageViewH = _favorersScrollView.frame.size.height;
    CGFloat headImageViewW = headImageViewH;
    NSUInteger index = 0;
    for (NSDictionary *dict in favorerArray) {
        if (index != 7) {
            CGFloat imageViewX = index * (headImageViewW + headImageViewS);
            NSString *headImageURL = dict[@"headImg"];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(imageViewX, 0, headImageViewW, headImageViewH);
            imageView.tag = index;
            imageView.userInteractionEnabled = YES;
            imageView.layer.cornerRadius = headImageViewW * 0.5;
            imageView.layer.masksToBounds = YES;
            NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:headImageURL
                                                                          width:headImageViewW
                                                                         height:headImageViewH];
            [imageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                         placeholderImage:[UIImage imageNamed:@"my_head_default"]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapHeadImageView:)];
            [imageView addGestureRecognizer:tap];
            
            [_favorersScrollView addSubview:imageView];
            
            index++;
        } else {
            break;
        }
    }
    _favorersScrollView.contentSize = CGSizeMake(headImageViewW * index + headImageViewS * (index - 1), headImageViewH);
}

- (void)tapHeadImageView:(UITapGestureRecognizer *)tap {
    UIView *headImageView = tap.view;
    NSDictionary *dict = _favorerArray[headImageView.tag];
    NSString *userId = dict[@"id"];
    if (_tapUserHeadImageBlock) {
        _tapUserHeadImageBlock(userId);
    }
}

- (IBAction)favourButtonClicked {
    if (_pushFavorerListViewControllerBlock) {
        _pushFavorerListViewControllerBlock();
    }
}

@end
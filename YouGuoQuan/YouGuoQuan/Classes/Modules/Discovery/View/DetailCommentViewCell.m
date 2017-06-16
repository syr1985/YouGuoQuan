//
//  VideoCommentViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/30.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "DetailCommentViewCell.h"
#import "DetailCommentModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+LXExtension.h"
#import <LCActionSheet.h>

@interface DetailCommentViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;

@end

@implementation DetailCommentViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.bounds.size.width * 0.5;
    self.headerImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapHeadGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapHeadImageView)];
    [self.headerImageView addGestureRecognizer:tapHeadGR];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(popKeyBoard:)];
    [self.contentView addGestureRecognizer:tapGR];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(popActionSheetMenu:)];
    [self.contentView addGestureRecognizer:longPressGR];
}

- (void)setDetailCommentModel:(DetailCommentModel *)detailCommentModel {
    _detailCommentModel = detailCommentModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:detailCommentModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    _nickNameLabel.text = detailCommentModel.fromUserNickName;
    _commentContentLabel.text = detailCommentModel.commentContent;
    
    _levelImageView.hidden = detailCommentModel.star == 0;
    if (detailCommentModel.star != 0) {
        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",detailCommentModel.star]];
    }
    
    NSTimeInterval timeInterval = [detailCommentModel.createTime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    LXDateItem *item = [[NSDate date] lx_timeIntervalSinceDate:createDate];
    _commentTimeLabel.text = [NSString stringWithFormat:@"%@",item.description];
}

- (void)popKeyBoard:(UITapGestureRecognizer *)sender {
    if (_tapCommentBlock) {
        _tapCommentBlock(_detailCommentModel);
    }
}

- (void)popActionSheetMenu:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (_longPressCommentBlock) {
            _longPressCommentBlock(_detailCommentModel);
        }
    }
}

- (void)tapHeadImageView {
    if (_tapHeadImageViewBlock) {
        _tapHeadImageViewBlock(_detailCommentModel.fromUserId);
    }
}

@end
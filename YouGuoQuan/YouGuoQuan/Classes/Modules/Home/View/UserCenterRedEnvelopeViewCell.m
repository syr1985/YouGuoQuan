//
//  UserCenterRedEnvelopeViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "UserCenterRedEnvelopeViewCell.h"
#import "UserCenterModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PhotoBrowserHelp.h"
#import "MoreMenuHelp.h"
#import "UIImage+LXExtension.h"
#import "UIImage+Color.h"

@interface UserCenterRedEnvelopeViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView  *redPacketBackgroundView;

@property (weak, nonatomic) IBOutlet UIButton *favourButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@end

NSString * const kUserCenterBuyPhotoSuccessNotification = @"BuyPhotoSuccessNotification";

@implementation UserCenterRedEnvelopeViewCell

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModelDataForComment:)
                                                 name:kUserCenterCommentSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModelDataForBuyPhoto:)
                                                 name:kUserCenterBuyPhotoSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModelDataForFavour:)
                                                 name:kFavourSuccessNotification
                                               object:nil];
}

- (void)setUserCenterModel:(UserCenterModel *)userCenterModel {
    _userCenterModel = userCenterModel;
    
    _moreButton.hidden = ![userCenterModel.userId isEqualToString:[LoginData sharedLoginData].userId];
    _titleLabel.text = userCenterModel.instro;
    _favourButton.selected = userCenterModel.praise;
    [_favourButton setTitle:[userCenterModel.recommendCount stringValue] forState:UIControlStateNormal];
    [_commentButton setTitle:[userCenterModel.commentCount stringValue] forState:UIControlStateNormal];
    
    _payButton.hidden = ![LoginData sharedLoginData].ope;
    [_payButton setTitle:[userCenterModel.buyCount stringValue] forState:UIControlStateNormal];
    
    [self downloadRedPacketImage];
}

- (void)downloadRedPacketImage {
    // 1.
    if (_redPacketBackgroundView.subviews.count) {
        for (UIView *view in _redPacketBackgroundView.subviews) {
            [view removeFromSuperview];
        }
    }
    // 2.
    NSUInteger margin = 6;
    CGFloat defaultW = (WIDTH - 24 - 2 * margin) / 3;
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:CGSizeMake(defaultW, defaultW)];
    
    BOOL isBlurImage =  !_userCenterModel.isBuy &&
                        ![_userCenterModel.userId isEqualToString:[LoginData sharedLoginData].userId] &&
                        [LoginData sharedLoginData].ope;
    if (_userCenterModel.imageUrl && _userCenterModel.imageUrl.length) {
        if ([_userCenterModel.imageUrl containsString:@";"]) {
            NSArray *urlArray = [_userCenterModel.imageUrl componentsSeparatedByString:@";"];
            NSUInteger count = urlArray.count;
            
            NSUInteger col = count == 4 ? 2 : (count > 2 ? 3 : count);
            NSUInteger row = count % 3 == 0 ? (count / 3) : (count / 3 + 1);
            
            CGFloat viewW = (WIDTH - 24 - (col - 1) * margin) / col;
            if (viewW > defaultW) {
                viewW = defaultW;
            }
            CGFloat viewH = viewW;
            for (NSUInteger i = 0; i < row; i++) {
                CGFloat viewY = (viewH + margin) * i;
                for (NSUInteger j = 0; j < col; j++) {
                    CGFloat viewX = (viewH + margin) * j;
                    NSUInteger index = i * col + j;
                    if (index < count) {
                        [self createImageViewWithImageX:viewX
                                                 imageY:viewY
                                                 imageW:viewW
                                                 imageH:viewH
                                               imageUrl:urlArray[index]
                                       placeHolderImage:phImage
                                                   blur:isBlurImage
                                           imageViewTag:index
                                            singleImage:NO];
                    }
                }
            }
        } else {
            defaultW = 178;
            
            [self createImageViewWithImageX:0
                                     imageY:0
                                     imageW:defaultW
                                     imageH:defaultW
                                   imageUrl:_userCenterModel.imageUrl
                           placeHolderImage:phImage
                                       blur:isBlurImage
                               imageViewTag:0
                                singleImage:YES];
        }
    }
}

- (void)createImageViewWithImageX:(CGFloat)x imageY:(CGFloat)y imageW:(CGFloat)w imageH:(CGFloat)h imageUrl:(NSString *)url placeHolderImage:(UIImage *)phImage blur:(BOOL)isBlurImage imageViewTag:(NSInteger)tag singleImage:(BOOL)single {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.tag = tag;
    imageView.frame = CGRectMake(x, y, w, h);
    imageView.userInteractionEnabled = YES;
    [_redPacketBackgroundView addSubview:imageView];
    NSString *imageUrlStr = [NSString cropImageUrlWithUrlString:url
                                                          width:w
                                                         height:h];
    if (isBlurImage) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:phImage options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                dispatch_queue_t blurImageDispatchQueue = dispatch_queue_create("cn.newtouch.YouGuoQuan.gcd.BlurImage", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(blurImageDispatchQueue, ^{
                    CGFloat radius = single ? 50 : image.size.width * 0.25;
                    UIImage *blurimage = [image blurImageWithRadius:radius];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = blurimage;
                    });
                });
            }
        }];
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                     placeholderImage:phImage];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(popupPhotoBrowser:)];
    [imageView addGestureRecognizer:tap];
}

/**
 *  点击赞按钮
 */
- (IBAction)favourToOther:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    if (sender.isSelected) {
        // 取消赞
        [NetworkTool cancelFavourWithFeedsID:_userCenterModel.trendsId userID:_userCenterModel.userId success:^{
            sender.selected = NO;
            NSInteger priseCount = [weakself.userCenterModel.recommendCount integerValue];
            NSNumber *newPriseCount = @(priseCount - 1);
            [[NSNotificationCenter defaultCenter] postNotificationName:kFavourSuccessNotification
                                                                object:nil
                                                              userInfo:@{@"NewFavourCount":newPriseCount,
                                                                         @"CurrentFocusID":_userCenterModel.trendsId,
                                                                         @"praise":@(NO)}];
        }];
    } else {
        // 点赞
        [NetworkTool doFavourWithFeedsID:_userCenterModel.trendsId userId:_userCenterModel.userId success:^{
            sender.selected = YES;
            NSInteger priseCount = [weakself.userCenterModel.recommendCount integerValue];
            NSNumber *newPriseCount = @(priseCount + 1);
            [[NSNotificationCenter defaultCenter] postNotificationName:kFavourSuccessNotification
                                                                object:nil
                                                              userInfo:@{@"NewFavourCount":newPriseCount,
                                                                         @"CurrentFocusID":_userCenterModel.trendsId,
                                                                         @"praise":@(YES)}];
        }];
    }
}

/**
 *  评论
 */
- (IBAction)messageToOther:(UIButton *)sender {
    if (_commentBlock) {
        _commentBlock(_userCenterModel);
    }
}

/**
 *  购买红包照片
 */
- (IBAction)payForRedPacket:(UIButton *)sender {
    if ([_userCenterModel.userId isEqualToString:[LoginData sharedLoginData].userId]) {
        return;
    }
    if (_userCenterModel.isBuy) {
        return;
    }
    if (_buyRedPacketBlock) {
        NSInteger price = 10;
        if ([_userCenterModel.imageUrl containsString:@";"]) {
            NSArray *urlArray = [_userCenterModel.imageUrl componentsSeparatedByString:@";"];
            NSInteger count = urlArray.count;
            if (count < 3) {
                price = 10;
            } else if (count < 5 && count > 2) {
                price = 30;
            } else if (count < 8 && count > 4) {
                price = 60;
            } else {
                price = 80;
            }
        }
        _buyRedPacketBlock(price, _userCenterModel.goodsId, _userCenterModel.trendsId);
    }
}

/**
 *  更多按钮点击
 */
- (IBAction)moreButtonClicked:(id)sender {
    __weak typeof(self) weakself = self;
    [MoreMenuHelp showMoreMenuForMineTrendsWithResult:^(NSUInteger buttonIndex) {
        if (weakself.actionSheetItemClicked) {
            weakself.actionSheetItemClicked(buttonIndex, weakself.userCenterModel.trendsId, weakself.userCenterModel.feedsType, weakself.indexPath);
        }
    }];
}

/**
 *  打开图片浏览器
 */
- (void)popupPhotoBrowser:(UITapGestureRecognizer *)sender {
    UIImageView *tapView = (UIImageView *)sender.view;
    if (!_userCenterModel.isBuy &&
        ![_userCenterModel.userId isEqualToString:[LoginData sharedLoginData].userId] &&
        [LoginData sharedLoginData].ope) {
        [self payForRedPacket:self.payButton];
        return;
    }
    
    if (_userCenterModel.imageUrl && _userCenterModel.imageUrl.length) {
        NSArray *urlArray;
        if ([_userCenterModel.imageUrl containsString:@";"]) {
            urlArray = [_userCenterModel.imageUrl componentsSeparatedByString:@";"];
        } else {
            urlArray = @[_userCenterModel.imageUrl];
        }
        [PhotoBrowserHelp openPhotoBrowserWithImages:urlArray sourceImageView:tapView];
    }
}

#pragma mark -
#pragma mark - 评论后更新模型数据
- (void)updateModelDataForComment:(NSNotification *)noti {
    NSNumber *content = noti.userInfo[@"NewCommentTimes"];
    NSString *focusId = noti.userInfo[@"CurrentFocusID"];
    if ([_userCenterModel.trendsId isEqualToString:focusId]) {
        _userCenterModel.commentCount = content;
        [_commentButton setTitle:[content stringValue] forState:UIControlStateNormal];
    }
}

- (void)updateModelDataForBuyPhoto:(NSNotification *)noti {
    NSString *feedsId = noti.userInfo[@"PhotoFeedsID"];
    if ([_userCenterModel.trendsId isEqualToString:feedsId]) {
        NSInteger buyCount = [self.userCenterModel.buyCount integerValue];
        NSString *newBuyCount = [NSString stringWithFormat:@"%zd",buyCount + 1];
        _userCenterModel.buyCount = @(buyCount + 1);
        _userCenterModel.isBuy = YES;
        [_payButton setTitle:newBuyCount forState:UIControlStateNormal];
//        if (!_payButton.isSelected) {
//            _payButton.selected = YES;
//        }
        [self downloadRedPacketImage];
    }
}

- (void)updateModelDataForFavour:(NSNotification *)noti {
    NSString *focusId = noti.userInfo[@"CurrentFocusID"];
    if ([_userCenterModel.trendsId isEqualToString:focusId]) {
        NSNumber *content = noti.userInfo[@"NewFavourCount"];
        NSNumber *praise  = noti.userInfo[@"praise"];
        _userCenterModel.recommendCount = content;
        [_favourButton setTitle:[content stringValue] forState:UIControlStateNormal];
        _userCenterModel.praise = [praise boolValue];
        _favourButton.selected = [praise boolValue];
    }
}

@end

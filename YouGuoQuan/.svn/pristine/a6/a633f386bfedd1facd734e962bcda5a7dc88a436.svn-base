//
//  CrowdfundingDetailHeaderView.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/29.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "CrowdfundingDetailHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DiscoveryCrowdfundingModel.h"
#import "NSString+AttributedText.h"
#import "UIImage+Color.h"

@interface CrowdfundingDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *participateInfoLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *participatenScrollView;
@property (weak, nonatomic) IBOutlet UIButton *maxParticipateNumberButton;
@property (nonatomic,   copy) NSString *money;
@property (nonatomic, strong) NSArray *participatenArray;
@end

@implementation CrowdfundingDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(lookParticipatenList)];
    [_participatenScrollView addGestureRecognizer:tapGesture];
}

- (void)lookParticipatenList {
    if (_pushViewControllerBlock) {
        _pushViewControllerBlock();
    }
}

- (void)setDiscoveryCrowdfundingModel:(DiscoveryCrowdfundingModel *)discoveryCrowdfundingModel {
    _discoveryCrowdfundingModel = discoveryCrowdfundingModel;
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_headerImageView.frame.size];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:discoveryCrowdfundingModel.coverImgUrl]
                        placeholderImage:phImage];
    
    __weak typeof(self) weakself = self;
    if (!self.money || !self.money.length) {
        [NetworkTool getMyContriMoneyWithCFId:discoveryCrowdfundingModel.crowdfundingId Success:^(id result) {
            weakself.money = result;
            NSString *joinCount = [NSString stringWithFormat:@"%zd人已参与，我已积累%@元",discoveryCrowdfundingModel.joinPeople,result];
            NSRange range = [joinCount rangeOfString:result];
            weakself.participateInfoLabel.attributedText = [NSString attributedStringWithString:joinCount
                                                                                          color:NavColor
                                                                                          range:range];
        } failure:nil];
    }
    
    if (!self.participatenArray || !self.participatenArray.count) {
        [NetworkTool getDiscoveryParticipatenListWithPageNo:@(1) pageSize:@(3) cfID:discoveryCrowdfundingModel.crowdfundingId success:^(id result) {
            weakself.maxParticipateNumberButton.hidden = ![result count];
            if ([result count]) {
                weakself.participatenArray = result;
                NSDictionary *firstDict = result[0];
                NSString *title = [NSString stringWithFormat:@"%@",firstDict[@"totalMoney"]];
                [weakself.maxParticipateNumberButton setTitle:title forState:UIControlStateNormal];
                
                NSInteger count = [result count];
                CGFloat viewH = _participatenScrollView.frame.size.height;
                for (NSInteger index = 0; index < count; index++) {
                    NSDictionary *infoDict = result[count - 1 - index];
                    CGFloat viewX = (count - 1 - index) * viewH * 0.5;
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.layer.cornerRadius = viewH * 0.5;
                    imageView.layer.masksToBounds = YES;
                    imageView.layer.borderWidth = 2;
                    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
                    imageView.frame = CGRectMake(viewX, 0, viewH, viewH);
                    [imageView sd_setImageWithURL:[NSURL URLWithString:infoDict[@"headImg"]]
                                 placeholderImage:[UIImage imageNamed:@"my_head_default"]];
                    [weakself.participatenScrollView addSubview:imageView];
                }
            }
        } failure:nil];
    }
}


@end

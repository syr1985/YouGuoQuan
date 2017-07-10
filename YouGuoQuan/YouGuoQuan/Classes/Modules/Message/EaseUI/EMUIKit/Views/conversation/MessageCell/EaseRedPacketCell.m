//
//  EaseRedPacketCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/2/7.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "EaseRedPacketCell.h"
#import "Masonry.h"
#import "NSString+AttributedText.h"

@interface EaseRedPacketCell ()
//@property (strong, nonatomic) UIImageView *redImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titlelabelBackView;
@end

@implementation EaseRedPacketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _setupSubview];
    }
    
    return self;
}

- (void)_setupSubview {
    //[self.titlelabelBackView addSubview:self.redImageView];
    [self.titlelabelBackView addSubview:self.titleLabel];
    [self.contentView addSubview:self.titlelabelBackView];
    
    [self _setupConstraints];
}

#pragma mark - Setup Constraints

- (void)_setupConstraints {
    __weak typeof(self) weakself = self;
    [self.titlelabelBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakself.contentView.mas_centerX);
        make.centerY.mas_equalTo(weakself.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.titlelabelBackView.mas_top).with.offset(2);
        make.bottom.mas_equalTo(weakself.titlelabelBackView.mas_bottom).with.offset(-2);
        make.left.mas_equalTo(weakself.titlelabelBackView.mas_left).with.offset(6.5);
        make.right.mas_equalTo(weakself.titlelabelBackView.mas_right).with.offset(-12);
    }];
    
//    [self.redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakself.titlelabelBackView.mas_left).with.offset(12);
//        make.bottom.mas_equalTo(weakself.titlelabelBackView.mas_bottom).with.offset(-2);
//        make.top.mas_equalTo(weakself.titlelabelBackView.mas_top).with.offset(2);
//        make.width.mas_equalTo(10);
//        make.height.mas_equalTo(12);
//    }];
}

- (void)setModel:(id<IMessageModel>)model {
    _model = model;
    NSString *str = @"";
    NSString *giftName = @"";
    switch ([model.text integerValue]) {
        case 80:
            giftName = @"冰淇淋";
            break;
        case 299:
            giftName = @"巧克力";
            break;
        case 666:
            giftName = @"蛋糕";
            break;
        case 1314:
            giftName = @"香水";
            break;
        case 2999:
            giftName = @"水晶鞋";
            break;
        case 5200:
            giftName = @"耳坠";
            break;
        case 9999:
            giftName = @"钻戒";
            break;
        case 19999:
            giftName = @"跑车";
            break;
        case 29999:
            giftName = @"游艇";
            break;
    }
    
    if (model.isSender) {
        str = [NSString stringWithFormat:@"您赠送了%@%@ 价值%@ u币",model.nickname,giftName,model.text];
    } else {
        str = [NSString stringWithFormat:@"%@赠送了您%@ 价值%@ u币",model.nickname,giftName,model.text];
    }
    NSRange range = [str rangeOfString:giftName];
    NSRange colorRange = [str rangeOfString:[str substringFromIndex:range.location]];
    NSAttributedString *attrStr = [NSString attributedStringWithString:str
                                                                 color:NavTabBarColor
                                                                 range:colorRange];
    self.titleLabel.attributedText = attrStr;
}

//- (UIImageView *)redImageView {
//    if (!_redImageView) {
//        _redImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"红包照片-发布状态"]];
//    }
//    return _redImageView;
//}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}

- (UIView *)titlelabelBackView {
    if (!_titlelabelBackView) {
        _titlelabelBackView = [[UIView alloc] init];
        _titlelabelBackView.clipsToBounds = YES;
        _titlelabelBackView.layer.cornerRadius = 3;
        _titlelabelBackView.backgroundColor = RGBA(0, 0, 0, 0.1);
    }
    return _titlelabelBackView;
}

+ (NSString *)cellIdentifier {
    return @"MessageRedPacketCell";
}

@end

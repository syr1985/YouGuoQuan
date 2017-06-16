//
//  SnapViewCell.m
//  YouGuoQuan
//
//  Created by liushuai on 2017/1/10.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "EaseSnapViewCell.h"
#import <Hyphenate_CN/EMSDKFull.h>
#import "UIImageView+EMWebCache.h"
#import "EMMessage.h"
#import "EaseBubbleView+Text.h"
#import "EaseBubbleView+Image.h"
#import "EaseBubbleView+Voice.h"
#import "EaseEmotionEscape.h"
#import <Masonry.h>

@interface EaseSnapViewCell()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *vipView;
@property (strong, nonatomic) UIImageView *recommandView;
@property (nonatomic, assign) BOOL addNotification;
@end

@implementation EaseSnapViewCell

@synthesize nameLabel = _nameLabel;

- (void)dealloc {
    NSLog(@"%s",__func__);
}

+ (void)initialize {
    // UIAppearance Proxy Defaults
    EaseSnapViewCell *cell = [self appearance];
    cell.avatarCornerRadius = 20;
    
    cell.messageNameColor = [UIColor grayColor];
    cell.messageNameFont = [UIFont systemFontOfSize:10];
    cell.messageNameHeight = 15;
    cell.messageNameIsHidden = YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<IMessageModel>)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = _messageNameFont;
        _nameLabel.textColor = _messageNameColor;
        [self.contentView addSubview:_nameLabel];
        
        _vipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像加V"]];
        _vipView.hidden = YES;
        [self.contentView addSubview:_vipView];
        __weak typeof(self) weakself = self;
        [_vipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.avatarView.mas_right);
            make.bottom.equalTo(weakself.avatarView.mas_bottom);
        }];
        _recommandView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"皇冠"]];
        _recommandView.hidden = YES;
        [self.contentView addSubview:_recommandView];
        [_recommandView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.avatarView.mas_left).offset(-2);
            make.top.equalTo(weakself.avatarView.mas_top).offset(-2);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        if (model.isSender) {
            [self configureSendLayoutConstraints];
        } else {
            [self configureRecvLayoutConstraints];
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bubbleView.backgroundImageView.image = self.model.isSender ? self.sendBubbleBackgroundImage : self.recvBubbleBackgroundImage;
}

- (void)configureSendLayoutConstraints {
    //avatar view
    __weak typeof(self) weakself = self;
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top).with.offset(EaseMessageCellPadding);
        make.right.equalTo(weakself.contentView.mas_right).with.offset(-EaseMessageCellPadding);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    //name label
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top);
        make.right.equalTo(weakself.avatarView.mas_left).with.offset(-EaseMessageCellPadding);
        make.height.mas_equalTo(15);
    }];
    
    //bubble view
    [self.bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.avatarView.mas_left).with.offset(-EaseMessageCellPadding);
        make.top.equalTo(weakself.nameLabel.mas_bottom);
    }];
    
    //status button
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.bubbleView.mas_left).with.offset(-EaseMessageCellPadding);
    }];
    
    //activity
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.bubbleView.mas_left).with.offset(-EaseMessageCellPadding);
    }];
    
    //hasRead
    [self.hasRead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.bubbleView.mas_left).with.offset(-EaseMessageCellPadding);
    }];
}

- (void)configureRecvLayoutConstraints {
    //avatar view
    __weak typeof(self) weakself = self;
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top).with.offset(EaseMessageCellPadding);
        make.left.equalTo(weakself.contentView.mas_left).with.offset(EaseMessageCellPadding);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    //name label
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView.mas_top);
        make.left.equalTo(weakself.avatarView.mas_right).with.offset(EaseMessageCellPadding);
        make.height.mas_equalTo(15);
    }];
    
    //bubble view
    [self.bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.avatarView.mas_right).with.offset(EaseMessageCellPadding);
        make.top.equalTo(weakself.nameLabel.mas_bottom);
    }];
}

- (void)deleteModel {
    
}

#pragma mark - setter

- (void)setInfoDict:(NSDictionary *)infoDict {
    _infoDict = infoDict;
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:infoDict[@"headImg"]]
                       placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    int vip = [infoDict[@"vip"] intValue];
    self.vipView.hidden = (vip != 1 && vip != 3);
    self.vipView.image =  vip == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    self.recommandView.hidden = ![infoDict[@"nobility"] boolValue];
}

- (void)setModel:(id<IMessageModel>)model {
    [super setModel:model];
    
    if (model.isSender) {
        model.avatarURLPath = [LoginData sharedLoginData].headImg;
        _vipView.hidden = [LoginData sharedLoginData].audit != 1 && [LoginData sharedLoginData].audit != 3;
        _vipView.image =  [LoginData sharedLoginData].audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
        _recommandView.hidden = ![LoginData sharedLoginData].isRecommend;
        
        _hasRead.hidden = YES;
        switch (self.model.messageStatus) {
            case EMMessageStatusDelivering:
            {
                _statusButton.hidden = YES;
                [_activity setHidden:NO];
                [_activity startAnimating];
            }
                break;
            case EMMessageStatusSuccessed:
            {
                _statusButton.hidden = YES;
                [_activity stopAnimating];
                if (self.model.isMessageRead) {
                    _hasRead.hidden = NO;
                }
            }
                break;
            case EMMessageStatusPending:
            case EMMessageStatusFailed:
            {
                [_activity stopAnimating];
                [_activity setHidden:YES];
                _statusButton.hidden = NO;
            }
                break;
            default:
                break;
        }
    } else {
        // 处理阅后即焚的视图
        __weak typeof(self) weakself = self;
        switch (model.bodyType) {
            case EMMessageBodyTypeText:
            {
                _bubbleView.deleteMessageBolck = ^{
                    if (weakself.deleteMessageBolckWithModel) {
                        weakself.deleteMessageBolckWithModel(weakself.model);
                    }
                };
                _bubbleView.sendMessageReadBolck = ^{
                    if (weakself.sendMessageReadBolckWithModel) {
                        weakself.sendMessageReadBolckWithModel(weakself.model);
                    }
                };
                
                if (model.isMessageRead) {
                    _bubbleView.textLabel.attributedText = [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:model.text textFont:weakself.messageTextFont];
                    
                    [_bubbleView countdown];
                } else {
                    [_bubbleView setupTextSnapView];
                }
            }
                break;
            case EMMessageBodyTypeImage:
            {
                [_bubbleView setupImageSnapView];
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                [_bubbleView setupVoiceSnapView];
                _bubbleView.voiceImageView.image = [UIImage imageNamed:@"语音气泡-阅后即焚"];
            }
                break;
            default:
                break;
        }
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath]
                           placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    } else {
        self.avatarView.image = model.avatarImage;
    }
    //_nameLabel.text = model.nickname;
}

- (void)setMessageNameFont:(UIFont *)messageNameFont {
    _messageNameFont = messageNameFont;
    if (_nameLabel) {
        _nameLabel.font = _messageNameFont;
    }
}

- (void)setMessageNameColor:(UIColor *)messageNameColor {
    _messageNameColor = messageNameColor;
    if (_nameLabel) {
        _nameLabel.textColor = _messageNameColor;
    }
}

- (void)setAvatarCornerRadius:(CGFloat)avatarCornerRadius {
    _avatarCornerRadius = avatarCornerRadius;
    if (self.avatarView){
        self.avatarView.layer.cornerRadius = avatarCornerRadius;
    }
}

- (void)setMessageNameIsHidden:(BOOL)messageNameIsHidden {
    _messageNameIsHidden = messageNameIsHidden;
    if (_nameLabel) {
        _nameLabel.hidden = messageNameIsHidden;
    }
}

#pragma mark - public

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model {
    EaseSnapViewCell *cell = [self appearance];
    
    if ([model.message.ext[@"fire"] boolValue] && !model.isSender) {
        if (model.bodyType == EMMessageBodyTypeImage) {
            return EaseMessageCellPadding + cell.bubbleMargin.top + cell.bubbleMargin.bottom + 132;
        } else if (model.bodyType == EMMessageBodyTypeText) {
            if (!model.isMessageRead) {
                return 65;
            }
        }
    }
    
    CGFloat minHeight = cell.avatarSize + EaseMessageCellPadding * 2;
    CGFloat height = cell.messageNameHeight;
    height += [EaseMessageCell cellHeightWithModel:model];
    height = height > minHeight ? height : minHeight;
    
    return height;
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model {
    NSString *cellIdentifier = nil;
    if (model.isSender) {
        switch (model.bodyType) {
            case EMMessageBodyTypeText:
                cellIdentifier = @"SnapMessageCellSendText";
                break;
            case EMMessageBodyTypeImage:
                cellIdentifier = @"SnapMessageCellSendImage";
                break;
            case EMMessageBodyTypeVoice:
                cellIdentifier = @"SnapMessageCellSendVoice";
                break;
            default:
                break;
        }
    } else {
        switch (model.bodyType) {
            case EMMessageBodyTypeText:
                cellIdentifier = @"SnapMessageCellRecvText";
                break;
            case EMMessageBodyTypeImage:
                cellIdentifier = @"SnapMessageCellRecvImage";
                break;
            case EMMessageBodyTypeVoice:
                cellIdentifier = @"SnapMessageCellRecvVoice";
                break;
            default:
                break;
        }
    }
    return cellIdentifier;
}
@end

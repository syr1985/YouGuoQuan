//
//  BlackListViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/2/23.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "BlackListViewCell.h"
#import "OthersFocusModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BlackListViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNamelabel;
@property (weak, nonatomic) IBOutlet UIButton *blackSwith;

@end

@implementation BlackListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width * 0.5;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setBlackListModel:(OthersFocusModel *)blackListModel {
    _blackListModel = blackListModel;
    
    NSString *imageUrlStr = [NSString compressImageUrlWithUrlString:blackListModel.headImg
                                                              width:_headerImageView.bounds.size.width
                                                             height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _vipImageView.hidden = !(blackListModel.audit == 1 || blackListModel.audit == 3);
    _vipImageView.image = blackListModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    _nickNamelabel.text = blackListModel.nickName;
    
    _blackSwith.selected = NO;
}

- (IBAction)changeSwtchStatus:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        // 取消拉黑
        __weak typeof(self) weakself = self;
        [NetworkTool doOperationWithType:@"3" userId:_blackListModel.userId operationType:@"0" success:^{
            [SVProgressHUD showSuccessWithStatus:@"已将对方从黑名单移除"];
            if (weakself.removeUserFromBlackList) {
                weakself.removeUserFromBlackList(weakself.blackListModel);
            }
        }];
    }
}


@end

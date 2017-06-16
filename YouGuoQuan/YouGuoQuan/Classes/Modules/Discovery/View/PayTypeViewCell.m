//
//  PayTypeViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/30.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PayTypeViewCell.h"

@interface PayTypeViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *payIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation PayTypeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    self.payIconImageView.image = [UIImage imageNamed:dict[@"imageName"]];
    
    self.payTypeLabel.text = dict[@"title"];
}

- (IBAction)selectButtonClicked:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected = !sender.isSelected;
        if (_selectPayType) {
            _selectPayType(_index);
        }
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.selectButton.selected = isSelected;
}

@end

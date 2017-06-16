//
//  OrderInfoViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/30.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "OrderInfoViewCell.h"

@interface OrderInfoViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *orderContentTextField;

@end

@implementation OrderInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    NSString *title = dict[@"title"];
    if ([title isEqualToString:@"电话："]) {
        _orderContentTextField.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([title isEqualToString:@"邮箱："]) {
        _orderContentTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    
    self.orderTitleLabel.text = title;
    self.orderContentTextField.placeholder = dict[@"placeholder"];
    
    [self.orderTitleLabel sizeToFit];
}

- (void)setPrice:(NSString *)price {
    _price = price;
    
    _orderContentTextField.text = price;
}

#pragma makr - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_textFieldDidEndEdit) {
        _textFieldDidEndEdit(textField.text, _index);
    }
}


@end

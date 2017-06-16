//
//  CityViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/29.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "CityViewCell.h"

@interface CityViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@end

@implementation CityViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCityName:(NSString *)cityName {
    _cityName = cityName;
    
    _cityNameLabel.text = cityName;
}

@end

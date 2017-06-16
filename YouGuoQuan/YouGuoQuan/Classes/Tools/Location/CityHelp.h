//
//  CityHelp.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/8.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityHelp : NSObject

+ (void)updateCitiesForLocation:(NSString *)city;

+ (void)updateCitiesForSelection:(NSString *)city;

@end

//
//  CityLocation.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/7.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CityLocation : NSObject 
@property (nonatomic,   copy) void (^locationSuccess)(NSString *city);
@property (nonatomic,   copy) void (^locationFailed)();
@property (nonatomic,   copy) void (^getCoordinate)(CLLocationCoordinate2D coordinate);

+ (instancetype)sharedInstance;
- (void)startLocation;
- (NSString *)getLocationCity;
- (CLLocationCoordinate2D)getLocationCoordinate;
@end

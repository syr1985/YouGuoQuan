//
//  WGS84TOGCJ02.h
//  YouGuoQuan
//
//  Created by YM on 2017/2/13.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WGS84TOGCJ02 : NSObject
// 判断是否已经超出中国范围
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
// 转GCJ-02
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
@end

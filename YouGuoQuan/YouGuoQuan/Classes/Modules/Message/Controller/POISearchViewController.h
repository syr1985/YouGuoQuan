//
//  POISearchViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/5/23.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMapPOI;
@interface POISearchViewController : UIViewController
@property (nonatomic,   copy) void (^sendLocationInfo)(AMapPOI *poi, NSString *mapImageURL);
@end

//
//  CrowdfundingDetailHeaderView.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/29.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscoveryCrowdfundingModel;
@interface CrowdfundingDetailHeaderView : UICollectionReusableView
@property (nonatomic, copy) void (^pushViewControllerBlock)();
@property (nonatomic, strong) DiscoveryCrowdfundingModel *discoveryCrowdfundingModel;
@end

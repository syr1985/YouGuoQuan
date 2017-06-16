//
//  BaseCollectionViewController.m
//  RoomService
//
//  Created by YM on 16/3/11.
//  Copyright © 2016年 SYR. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController () <UIScrollViewDelegate>

@end

@implementation BaseCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    //    UILabel *titleLabel = [[UILabel alloc] init];
    //    titleLabel.frame = CGRectMake(0, 0, 100, 44);
    //    titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    self.navigationItem.titleView = titleLabel;
    //    self.titleLabel = titleLabel;
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


@end

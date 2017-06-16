//
//  SearchResultViewController.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/21.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,   copy) NSString *searchText;
@end

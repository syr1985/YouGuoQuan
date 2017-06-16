//
//  LocationViewController.m
//  RoomService
//
//  Created by YM on 16/1/16.
//  Copyright © 2016年 SYR. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationCell.h"
#import "CityViewCell.h"
#import "CityHelp.h"
#import "CityLocation.h"
#import "ZYPinYinSearch.h"
#import "UISearchBar+LeftPlaceholder.h"

@interface LocationViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSDictionary *dictionary;
@end

static NSString *locationId = @"LocationCity";
static NSString *Identifier = @"CityViewCell";

@implementation LocationViewController

#pragma mark - Getter and Setter
- (NSMutableArray *)titlesArray {
    if (_titlesArray == nil) {
        _titlesArray = [NSMutableArray new];
        [_titlesArray addObject:@"定位"];
        [_titlesArray addObject:@"最近"];
        [_titlesArray addObject:@"热门"];
    }
    return _titlesArray;
}

- (NSDictionary *)dictionary {
    if (_dictionary == nil) {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        //取得目标文件路径
        NSString *citiesDocPath = [docPath stringByAppendingPathComponent:@"YGQ_CITIES.plist"];
        NSFileManager *fm = [NSFileManager defaultManager];
        //如果目标文件不存在说明是App第一次运行,需要将相关可修改数据文件拷贝至目标路径.
        if (![fm fileExistsAtPath:citiesDocPath]) {
            NSError *error = nil;
            //取得源文件路径
            NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
            if (![fm copyItemAtPath:srcPath toPath:citiesDocPath error:&error]) {
                
            }
        }
        _dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:citiesDocPath];
    }
    return _dictionary;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"当前城市";
    
    [self.searchBar changeLeftPlaceholder:self.searchBar.placeholder];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(popViewController)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    for (int i = 0; i < 26; i++) {
        if (i == 8 || i == 14 || i == 20 || i== 21) {
            continue;
        }
        NSString *cityKey = [NSString stringWithFormat:@"%c",i + 65];
        [self.titlesArray addObject:cityKey];
    }
    
    self.tableView.backgroundColor = BackgroundColor;
    [self.tableView registerClass:[LocationCell class] forCellReuseIdentifier:locationId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titlesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 3) {
        return 1;
    }
    NSString *cityKey = [self.titlesArray objectAtIndex:section];
    NSArray *array = [self.dictionary objectForKey:cityKey];
    return [array count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakself = self;
    if (indexPath.section == 0) {
        NSString *cityKey = [self.titlesArray objectAtIndex:indexPath.section];
        NSArray *array = [self.dictionary objectForKey:cityKey];
        LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:locationId];
        cell.cities = array;
        cell.selectedCityBlock = ^(NSString *city) {
            if ([city isEqualToString:@"重新定位"]) {
                [CityLocation sharedInstance].locationSuccess = ^(NSString *city) {
                    [weakself.tableView reloadData];
                };
                [CityLocation sharedInstance].locationFailed = ^ {
                    [weakself.tableView reloadData];
                };
                [[CityLocation sharedInstance] startLocation];
            } else {
                weakself.cityBlock(city);
                [CityHelp updateCitiesForSelection:city];
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        };
        return cell;
    } else if (indexPath.section == 1 || indexPath.section == 2) {
        NSString *cityKey = [self.titlesArray objectAtIndex:indexPath.section];
        NSArray *array = [self.dictionary objectForKey:cityKey];
        LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:locationId];
        cell.cities = array;
        cell.selectedCityBlock = ^(NSString *city) {
            weakself.cityBlock(city);
            [CityHelp updateCitiesForSelection:city];
            [weakself.navigationController popViewControllerAnimated:YES];
        };
        return cell;
    } else {
        CityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        NSString *cityKey = [self.titlesArray objectAtIndex:indexPath.section];
        NSArray *array = [self.dictionary objectForKey:cityKey];
        cell.cityName = array[indexPath.row];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3 ) {
        return;
    }
    NSString *cityKey = [self.titlesArray objectAtIndex:indexPath.section];
    NSArray *array = [self.dictionary objectForKey:cityKey];
    NSString *city = array[indexPath.row];
    [CityHelp updateCitiesForSelection:city];
    if (_cityBlock) {
        _cityBlock(city);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
        NSString *cityKey = [self.titlesArray objectAtIndex:indexPath.section];
        NSArray *cities = [self.dictionary objectForKey:cityKey];
        NSUInteger row = ceil(cities.count / 3.0);
        return row * 30 + (row + 1) * 12;
    } else if (indexPath.section == 0) {
        return 54;
    } else {
        return 56;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 23)];
    headerView.backgroundColor = TextFieldBorderColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, WIDTH - 20, 23)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [HelperUtil colorWithHexString:@"#858585"];
    NSString *title = [self.titlesArray objectAtIndex:section];
    if ([title isEqualToString:@"最近"]) {
        title = @"最近访问城市";
    } else if ([title isEqualToString:@"定位"]) {
        title = @"定位城市";
    } else if ([title isEqualToString:@"热门"]) {
        title = @"热门城市";
    }
    label.text = title;
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 23;
}

//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.titlesArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.titlesArray indexOfObject:title];;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    for (NSString *key in self.titlesArray) {
        NSArray *cities = self.dictionary[key];
        
        NSArray *searchArray = [ZYPinYinSearch searchWithOriginalArray:cities
                                                         andSearchText:searchBar.text
                                               andSearchByPropertyName:@""];
        if (searchArray.count) {
            NSUInteger section = [self.titlesArray indexOfObject:key];
            NSUInteger row = [cities indexOfObject:searchArray[0]];
            if (section < 3) {
                row = 0;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
    }
}

@end

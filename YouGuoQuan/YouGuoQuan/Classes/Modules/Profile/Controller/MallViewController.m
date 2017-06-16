//
//  MallViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/10.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "MallViewController.h"
#import "MallBannerViewCell.h"
#import "MallPrizeViewCell.h"

@interface MallViewController () <UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@end

@implementation MallViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

#pragma mark -
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UICollectionView DataSource and Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 4;//self.modelArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MallBannerViewCell *cell_banner = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallBannerViewCell" forIndexPath:indexPath];
        
        return cell_banner;
    } else {
        MallPrizeViewCell *cell_recource = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallPrizeViewCell" forIndexPath:indexPath];
        //cell_recource.homeResourceModel = self.modelArray[indexPath.row];
        
        return cell_recource;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    if (indexPath.section == 0) {
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat itemH = WIDTH * 46 / 75 + 45;
        return CGSizeMake(WIDTH, itemH);
    } else {
        flowLayout.minimumLineSpacing = 6;
        flowLayout.minimumInteritemSpacing = 6;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 6, 0, 6);
        CGFloat itemW = (WIDTH - 18) / 2;
        CGFloat itemH = itemW + 65;
        return CGSizeMake(itemW, itemH);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        UIStoryboard *mallSB = [UIStoryboard storyboardWithName:@"Mall" bundle:nil];
        UIViewController *prizeDetailVC = [mallSB instantiateViewControllerWithIdentifier:@"PrizeExchangeVC"];
        [self.navigationController pushViewController:prizeDetailVC animated:YES];
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

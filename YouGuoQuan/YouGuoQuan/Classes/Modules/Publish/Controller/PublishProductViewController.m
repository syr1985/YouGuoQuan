//
//  PublishProductViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/17.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PublishProductViewController.h"
#import "ChooseProductPriceViewController.h"
#import "PublishProductHeaderView.h"
#import "PublishProductFooterView.h"
#import "ProductPhotoViewCell.h"

#import "TakePhotoHelp.h"
#import "AlertViewTool.h"

@interface PublishProductViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *publishProductButton;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic,   copy) NSString       *coverUrl;
@property (nonatomic,   copy) NSString       *photosSize;
@property (nonatomic,   copy) NSString       *productName;
@property (nonatomic,   copy) NSString       *productPrice;
@property (nonatomic,   copy) NSString       *productIntro;
@property (nonatomic, strong) UIImage        *coverImage;
@property (nonatomic, assign) BOOL           isCover;
@property (nonatomic, assign) BOOL           isUploadOrignalPhoto;
@property (nonatomic, strong) NSNumber       *price;
@end

static NSString * const collectionViewCellID_Header = @"PublishProductHeaderView";
static NSString * const collectionViewCellID_Footer = @"PublishProductFooterView";
static NSString * const collectionViewCellID_Photo  = @"ProductPhotoViewCell";

NSString * const kNotification_PublishSuccess = @"kNotification_PublishSuccess";

@implementation PublishProductViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray new];
        [_photoArray addObject:[UIImage imageNamed:@"发布-添加"]];
    }
    return _photoArray;
}

#pragma mark - 
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BackgroundColor;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UICollectionViewFlowLayout *flowLaout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLaout.minimumLineSpacing = 3;
    flowLaout.minimumInteritemSpacing = 3;
    flowLaout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 9);
    CGFloat itemW = (WIDTH - 27) / 3;
    flowLaout.itemSize = CGSizeMake(itemW, itemW);
    flowLaout.headerReferenceSize = CGSizeMake(WIDTH, WIDTH * 46 / 75 + 244);
    flowLaout.footerReferenceSize = CGSizeMake(WIDTH, 30);
}

- (void)viewWillAppear:(BOOL)animated {
    if (![LoginData sharedLoginData].userId) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s",__func__);
}

#pragma mark -
#pragma mark - 关闭页面
- (IBAction)dismissViewController {
    __weak typeof(self) weakself = self;
    [AlertViewTool showAlertViewWithTitle:nil Message:@"您确认放弃此次操作吗？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
    } cancelBlock:nil];
}

#pragma mark -
#pragma mark - 调取接口

- (IBAction)publishProduct:(UIButton *)sender {
    sender.enabled = NO;
    [SVProgressHUD showWithStatus:@"发布商品"];
    NSData *imageData = UIImageJPEGRepresentation(self.coverImage,0.8);
    if (!_isUploadOrignalPhoto) {
        imageData = UIImageJPEGRepresentation(self.coverImage,0.1);
    }
 
    [NetworkTool uploadImage:imageData progress:nil success:^(NSString *url) {
        self.coverUrl = url;
        if (self.photoArray.count == 1) {
            [self publish:@""];
        } else {
            [self uploadImages];
        }
    } failure:^{
        [self publishFailure];
    }];
}

- (void)uploadImages {
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSUInteger i = 0 ; i < self.photoArray.count - 1; i++) {
        UIImage *image = self.photoArray[i];
        NSData *imageData = nil;
        if (_isUploadOrignalPhoto) {
            imageData = UIImageJPEGRepresentation(image,0.9);
        } else {
            imageData = UIImageJPEGRepresentation(image,0.5);
        }
        if (imageData) {
            [muArray addObject:imageData];
        }
    }
    
    [NetworkTool uploadImages:muArray
                     progress:nil
                      success:^(NSArray *urlArray) {
                          [self pornImageWithUrls:urlArray];
                      } failure:^{
                          [self publishFailure];
                      }];
}

- (void)pornImageWithUrls:(NSArray *)urlArray {
    //    if ([urlArray containsObject:@""]) {
    //        [SVProgressHUD showInfoWithStatus:@"您的图片违反了相关规定，无法上传"];
    //        return;
    //    }
    NSMutableString *urlString = [NSMutableString string];
    for (NSString *url in urlArray) {
        [urlString appendString:url];
        [urlString appendString:@";"];
    }
    NSUInteger maxRange = NSMaxRange([urlString rangeOfComposedCharacterSequenceAtIndex:urlString.length - 2]);
    [self publish:[urlString substringToIndex:maxRange]];
}

- (void)publish:(NSString *)imageUrl {
    [NetworkTool publishProduct:_productName
                          price:_price
                          cover:_coverUrl
                          image:imageUrl
                          intro:_productIntro
                        success:^{
                            [self publishSuccess];
                        } failure:^{
                            [self publishFailure];
                        }];
}

- (void)publishSuccess {
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_PublishSuccess object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"发布商品成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)publishFailure {
    self.publishProductButton.enabled = YES;
    [SVProgressHUD dismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:@"发布商品失败"];
    });
}

#pragma mark -
#pragma mark - UICollectionView DataSource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductPhotoViewCell *cell_photo = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID_Photo forIndexPath:indexPath];
    cell_photo.photo = self.photoArray[indexPath.row];
    cell_photo.index = indexPath.row;
    cell_photo.isShowDeleteButton = (indexPath.row == (self.photoArray.count - 1));
    
    __weak typeof(self) weakself = self;
    cell_photo.deletePhotoBlock = ^(NSUInteger index) {
        [weakself.photoArray removeObjectAtIndex:index];
        [weakself.collectionView reloadData];
    };
    
    return cell_photo;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        PublishProductFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:collectionViewCellID_Footer
                                                                                         forIndexPath:indexPath];
        footerview.photosSize = self.photosSize;
        __weak typeof(self) weakself = self;
        footerview.setUploadOrignalPhoto = ^(BOOL isUploadOrignalPhoto) {
            weakself.isUploadOrignalPhoto = isUploadOrignalPhoto;
        };
        reusableview = footerview;
    } else {
        PublishProductHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:collectionViewCellID_Header
                                                                                         forIndexPath:indexPath];
        headerview.coverImage = _coverImage;
        headerview.priceText  = _productPrice;
        
        __weak typeof(self) weakself = self;
        headerview.openPhotoAlbumBlock = ^() {
            //[weakself takePhotoWithActionSheetWithTitle:@"设置封面"];
            [[TakePhotoHelp sharedInstance] showActionSheetWithTitle:@"设置封面" viewController:weakself returnBlock:^(BOOL isCover, NSArray<UIImage *> *photos) {
                weakself.isCover = isCover;
                /**
                 *  刷新界面
                 */
                if (isCover) {
                    weakself.coverImage = photos[0];
                    
                    weakself.publishProductButton.enabled = weakself.productName.length && weakself.productPrice.length && weakself.coverImage;
                } else {
                    NSArray *oldArray = weakself.photoArray;
                    NSMutableArray *muArray = [NSMutableArray array];
                    [muArray addObjectsFromArray:photos];
                    [muArray addObjectsFromArray:oldArray];
                    weakself.photoArray = muArray;
                }
                [weakself.collectionView reloadData];
            }];
        };
        headerview.setProductInfo = ^(NSString *productName, NSString *productIntro) {
            weakself.productName = productName;
            weakself.productIntro = productIntro;
            weakself.publishProductButton.enabled = productName.length && weakself.productPrice.length && weakself.coverImage;
        };
        headerview.selectProductPriceBlock = ^{
            UIStoryboard *publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
            ChooseProductPriceViewController *choosePriceVC = [publishSB instantiateViewControllerWithIdentifier:@"ChooseProductPriceVC"];
            choosePriceVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            __weak typeof(self) weakself = self;
            choosePriceVC.selectPublishPriceBlock = ^(NSString *text, NSNumber *price) {
                weakself.price = price;
                weakself.productPrice = text;
                [weakself.collectionView reloadData];
            };
            [self presentViewController:choosePriceVC animated:YES completion:nil];
        };
        
        reusableview = headerview;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.photoArray.count - 1) {
        if (_photoArray.count > 9) {
            [SVProgressHUD showInfoWithStatus:@"照片数量已达上限"];
            return;
        }
        __weak typeof(self) weakself = self;
        [[TakePhotoHelp sharedInstance] showActionSheetWithTitle:@"配置商品图片" photosCount:_photoArray.count viewController:self returnBlock:^(BOOL isCover, NSArray<UIImage *> *photos) {
            weakself.isCover = isCover;
            /**
             *  刷新界面
             */
            if (isCover) {
                weakself.coverImage = photos[0];
            } else {
                NSArray *oldArray = weakself.photoArray;
                NSMutableArray *muArray = [NSMutableArray array];
                [muArray addObjectsFromArray:photos];
                [muArray addObjectsFromArray:oldArray];
                weakself.photoArray = muArray;
            }
            [weakself.collectionView reloadData];
        }];
    }
}

@end

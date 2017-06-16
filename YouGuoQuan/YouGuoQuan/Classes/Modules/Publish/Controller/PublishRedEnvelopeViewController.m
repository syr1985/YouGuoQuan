//
//  PublishRedEnvelopeViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/22.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PublishRedEnvelopeViewController.h"
#import "RedEnvelopeHeaderView.h"
#import "PublishProductFooterView.h"
#import "RedEnvelopeViewCell.h"

#import "TakePhotoHelp.h"
#import "AlertViewTool.h"

@interface PublishRedEnvelopeViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic,   copy) NSString       *photosSize;
@property (nonatomic,   copy) NSString       *redEnvelopeTitle;
@property (nonatomic, assign) BOOL           isUploadOrignalPhoto;
@end

static NSString * const collectionViewCellID_Header = @"RedEnvelopeHeaderView";
static NSString * const collectionViewCellID_Footer = @"PublishProductFooterView";
static NSString * const collectionViewCellID_Photo  = @"RedEnvelopeViewCell";

@implementation PublishRedEnvelopeViewController

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
    flowLaout.sectionInset = UIEdgeInsetsMake(0, 12, 12, 9);
    CGFloat itemW = (WIDTH - 27) / 3;
    flowLaout.itemSize = CGSizeMake(itemW, itemW);;
    flowLaout.headerReferenceSize = CGSizeMake(WIDTH, 180);
    flowLaout.footerReferenceSize = CGSizeMake(WIDTH, 30);
    
    UIStoryboard *publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
    UIViewController *publishRuleVC = [publishSB instantiateViewControllerWithIdentifier:@"PublishRedEnvelopeRuleVC"];
    publishRuleVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:publishRuleVC animated:YES completion:nil];
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
#pragma mark - 发布红包
- (IBAction)publishRedEnvelope:(id)sender {
    if (!self.redEnvelopeTitle || !self.redEnvelopeTitle.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入文字描述"];
        return;
    }
    
    if (self.photoArray.count < 2) {
        [SVProgressHUD showInfoWithStatus:@"请至少上传一张照片"];
        return;
    }
    
    /**
     *  上传图片
     */
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSUInteger i = 0 ; i < self.photoArray.count - 1; i++) {
        UIImage *image = self.photoArray[i];
        NSData *imageData = nil;
        if (!_isUploadOrignalPhoto) {
            imageData = UIImageJPEGRepresentation(image,0.1);
        } else {
            imageData = UIImageJPEGRepresentation(image,0.8);
        }
        if (imageData) {
            [muArray addObject:imageData];
        }
    }
    
    __weak typeof(self) weakself = self;
    [NetworkTool uploadImages:muArray progress:^(CGFloat percent) {
        [SVProgressHUD showProgress:percent status:@"正在上传图片"];
    } success:^(NSArray *urlArray) {
        NSMutableString *urlString = [NSMutableString string];
        for (NSString *url in urlArray) {
            [urlString appendString:url];
            [urlString appendString:@";"];
        }
        
        NSUInteger maxRange = NSMaxRange([urlString rangeOfComposedCharacterSequenceAtIndex:urlString.length - 2]);
        NSString *imageUrl = [urlString substringToIndex:maxRange];
        
        NSInteger photoCount = weakself.photoArray.count - 1;
        NSInteger price = 10;
        if (photoCount < 3) {
            price = 10;
        } else if (photoCount < 5 && photoCount > 2) {
            price = 30;
        } else if (photoCount < 8 && photoCount > 4) {
            price = 60;
        } else {
            price = 80;
        }

        [SVProgressHUD showWithStatus:@"发布红包照片"];
        [NetworkTool publishRedEnvelope:@(price) image:imageUrl intro:weakself.redEnvelopeTitle success:^{
            [SVProgressHUD showInfoWithStatus:@"发布红包照片成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_PublishSuccess object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakself dismissViewControllerAnimated:YES completion:nil];
            });
        } failure:^{
            [SVProgressHUD showInfoWithStatus:@"发布红包照片失败"];
            [SVProgressHUD dismissWithDelay:HUD_SHOW_TIME];
        }];
    } failure:^{
        [SVProgressHUD showInfoWithStatus:@"上传图片失败"];
        [SVProgressHUD dismissWithDelay:HUD_SHOW_TIME];
    }];
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
    RedEnvelopeViewCell *cell_photo = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID_Photo forIndexPath:indexPath];
    cell_photo.photo = self.photoArray[indexPath.row];
    cell_photo.index = indexPath.row;
    cell_photo.isShowDeleteButton = (indexPath.row == (self.photoArray.count - 1));
    cell_photo.isHiddenBlurView = (indexPath.row == (self.photoArray.count - 1) );
    
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
        RedEnvelopeHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                               withReuseIdentifier:collectionViewCellID_Header
                                                                                      forIndexPath:indexPath];
        __weak typeof(self) weakself = self;
        headerview.setTitle = ^(NSString *title) {
            weakself.redEnvelopeTitle = title;
            weakself.publishButton.enabled = title.length && weakself.photoArray.count > 1;
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
        [[TakePhotoHelp sharedInstance] showActionSheetWithTitle:@"配置红包图片" photosCount:_photoArray.count viewController:self returnBlock:^(BOOL isCover, NSArray<UIImage *> *photos) {
            if (!isCover) {
                NSArray *oldArray = weakself.photoArray;
                NSMutableArray *muArray = [NSMutableArray array];
                [muArray addObjectsFromArray:photos];
                [muArray addObjectsFromArray:oldArray];
                weakself.photoArray = muArray;
                weakself.publishButton.enabled = weakself.redEnvelopeTitle.length && weakself.photoArray.count > 1;
            }
            [weakself.collectionView reloadData];
        }];
    }
}

@end

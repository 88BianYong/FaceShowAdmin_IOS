//
//  ProjectFilterViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectFilterViewController.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
#import "FilterItemCell.h"
#import "FilterHeaderView.h"
#import "CustomTimeSettingView.h"

@interface ProjectFilterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger firstLevelSelectedIndex;
@property (nonatomic, assign) NSInteger secondLevelSelectedIndex;
@property (nonatomic, assign) NSInteger thirdLevelSelectedIndex;

@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, strong) NSArray *timeArray;
@end

@implementation ProjectFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"筛选";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"确定" action:^{
        STRONG_SELF
    }];
    self.cityArray = @[@"武汉",@"宜昌",@"襄阳",@"荆门",@"黄冈",@"恩施"];
    self.areaArray = @[@"江岸区",@"江汉区",@"昌平区",@"大兴区",@"朝阳区",@"海淀区"];
    self.timeArray = @[@"全部",@"本周",@"本月",@"近三月",@"自定义"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    flowLayout.itemSize = CGSizeMake(65, 28);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(5, 0, 20, 0);
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[FilterItemCell class] forCellWithReuseIdentifier:@"FilterItemCell"];
    [self.collectionView registerClass:[FilterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderView"];
    [self.collectionView registerClass:[CustomTimeSettingView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CustomTimeSettingView"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, -500, SCREEN_WIDTH, 500)];
    topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.collectionView addSubview:topView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.cityArray.count;
    }else if (section == 1) {
        return self.areaArray.count;
    }else {
        return self.timeArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterItemCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.title = self.cityArray[indexPath.row];
        cell.isCurrent = indexPath.row==self.firstLevelSelectedIndex;
    }else if (indexPath.section == 1){
        cell.title = self.areaArray[indexPath.row];
        cell.isCurrent = indexPath.row==self.secondLevelSelectedIndex;
    }else if (indexPath.section == 2){
        cell.title = self.timeArray[indexPath.row];
        cell.isCurrent = indexPath.row==self.thirdLevelSelectedIndex;
    }
    WEAK_SELF
    [cell setClickBlock:^(FilterItemCell *item){
        STRONG_SELF
        if (item.isCurrent) {
            return;
        }
        if (indexPath.section == 0) {
            self.firstLevelSelectedIndex = indexPath.row;
            self.secondLevelSelectedIndex = 0;
        }else if (indexPath.section == 1) {
            self.secondLevelSelectedIndex = indexPath.row;
        }else if (indexPath.section == 2) {
            self.thirdLevelSelectedIndex = indexPath.row;
        }
        [self.collectionView reloadData];
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        FilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.title = @"地市";
        }else if (indexPath.section == 1){
            headerView.title = @"区县";
        }else if (indexPath.section == 2){
            headerView.title = @"时间";
        }
        return headerView;
    }else if (indexPath.section == 2) {
        CustomTimeSettingView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CustomTimeSettingView" forIndexPath:indexPath];
        footer.hidden = self.thirdLevelSelectedIndex != self.timeArray.count-1;
        return footer;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 120);
    }
    return CGSizeZero;
}

@end

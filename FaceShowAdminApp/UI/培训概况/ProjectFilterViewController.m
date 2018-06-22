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
#import "GetUserManagerScopeRequest.h"
#import "ErrorView.h"
#import "AreaManager.h"

@interface ProjectFilterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CustomTimeSettingView *timeSettingView;
@property (nonatomic, assign) NSInteger firstLevelSelectedIndex;
@property (nonatomic, assign) NSInteger secondLevelSelectedIndex;
@property (nonatomic, assign) NSInteger thirdLevelSelectedIndex;
@property (nonatomic, assign) NSInteger fourthLevelSelectedIndex;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) GetUserManagerScopeRequest *scopeRequest;
@property (nonatomic, strong) GetUserManagerScopeRequestItem *requestItem;

@property (nonatomic, strong) NSMutableArray<Area *> *provinceArray;
@property (nonatomic, strong) NSMutableArray<Area *> *cityArray;
@property (nonatomic, strong) NSMutableArray<Area *> *areaArray;
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
        [self submitFilter];
    }];
    self.firstLevelSelectedIndex = 0;
    self.secondLevelSelectedIndex = -1;
    self.thirdLevelSelectedIndex = -1;

    self.timeArray = @[@"全部",@"本周",@"本月",@"近三月",@"自定义"];
    [self setupUI];
    [self requestScope];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitFilter {
    NSString *provinceID = self.provinceArray[self.firstLevelSelectedIndex].areaID;
    NSString *cityID = self.secondLevelSelectedIndex != -1? self.cityArray[self.secondLevelSelectedIndex].areaID:nil;
    NSString *districtID = self.thirdLevelSelectedIndex != -1? self.areaArray[self.thirdLevelSelectedIndex].areaID:nil;
    NSString *startTime = nil;
    NSString *endTime = nil;
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if (self.fourthLevelSelectedIndex == 1) {
        endTime = [dateFormatter stringFromDate:date];
        NSDate *startDate = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:date];
        startTime = [dateFormatter stringFromDate:startDate];
    }else if (self.fourthLevelSelectedIndex == 2) {
        endTime = [dateFormatter stringFromDate:date];
        NSDate *startDate = [NSDate dateWithTimeInterval:-30*24*60*60 sinceDate:date];
        startTime = [dateFormatter stringFromDate:startDate];
    }else if (self.fourthLevelSelectedIndex == 3) {
        endTime = [dateFormatter stringFromDate:date];
        NSDate *startDate = [NSDate dateWithTimeInterval:-90*24*60*60 sinceDate:date];
        startTime = [dateFormatter stringFromDate:startDate];
    }else if (self.fourthLevelSelectedIndex == 4) {
        startTime = self.timeSettingView.startTime;
        endTime = self.timeSettingView.endTime;
    }
    BLOCK_EXEC(self.selectBlock,provinceID,cityID,districtID,startTime,endTime);
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
    self.collectionView.hidden = YES;
    
    WEAK_SELF
    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestScope];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

- (void)requestScope {
    [self.view nyx_startLoading];
    [self.scopeRequest stopRequest];
    self.scopeRequest = [[GetUserManagerScopeRequest alloc]init];
    GetUserPlatformRequestItem_platformInfos *plat = [UserManager sharedInstance].userModel.platformRequestItem.data.platformInfos.firstObject;
//    self.scopeRequest.platId = plat.platformId;
#warning 先写死101测试
    self.scopeRequest.platId = @"101";
    WEAK_SELF
    [self.scopeRequest startRequestWithRetClass:[GetUserManagerScopeRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        self.requestItem = retItem;
        [self setupData];
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }];
}

- (void)setupData {
    [self setupProcince];
    [self setupCityWithProvince:self.provinceArray.firstObject];
}

- (void)setupProcince {
    self.provinceArray = [NSMutableArray array];
    for (NSNumber *province in self.requestItem.data.provinceIdScope) {
        for (Area *area in [AreaManager sharedInstance].areaModel.data) {
            if (province.integerValue == area.areaID.integerValue) {
                [self.provinceArray addObject:area];
                break;
            }
        }
    }
}

- (void)setupCityWithProvince:(Area *)province {
    self.cityArray = [NSMutableArray array];
    for (NSNumber *city in self.requestItem.data.cityIdScope) {
        for (Area *area in province.sub) {
            if (city.integerValue == area.areaID.integerValue) {
                [self.cityArray addObject:area];
                break;
            }
        }
    }
}

- (void)setupAreaWithCity:(Area *)city {
    self.areaArray = [NSMutableArray array];
    for (NSNumber *district in self.requestItem.data.districtIdScope) {
        for (Area *area in city.sub) {
            if (district.integerValue == area.areaID.integerValue) {
                [self.areaArray addObject:area];
                break;
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.provinceArray.count;
    }else if (section == 1) {
        return self.cityArray.count;
    }else if (section == 2) {
        if (self.secondLevelSelectedIndex == -1) {
            return 0;
        }
        return self.areaArray.count;
    }else {
        return self.timeArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterItemCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.title = self.provinceArray[indexPath.row].name;
        cell.isCurrent = indexPath.row==self.firstLevelSelectedIndex;
    }else if (indexPath.section == 1){
        cell.title = self.cityArray[indexPath.row].name;
        cell.isCurrent = indexPath.row==self.secondLevelSelectedIndex;
    }else if (indexPath.section == 2){
        cell.title = self.areaArray[indexPath.row].name;
        cell.isCurrent = indexPath.row==self.thirdLevelSelectedIndex;
    }else if (indexPath.section == 3){
        cell.title = self.timeArray[indexPath.row];
        cell.isCurrent = indexPath.row==self.fourthLevelSelectedIndex;
    }
    WEAK_SELF
    [cell setClickBlock:^(FilterItemCell *item){
        STRONG_SELF
        if (item.isCurrent) {
            return;
        }
        if (indexPath.section == 0) {
            self.firstLevelSelectedIndex = indexPath.row;
            self.secondLevelSelectedIndex = -1;
            self.thirdLevelSelectedIndex = -1;
            [self setupCityWithProvince:self.provinceArray[indexPath.row]];
        }else if (indexPath.section == 1) {
            self.secondLevelSelectedIndex = indexPath.row;
            self.thirdLevelSelectedIndex = -1;
            [self setupAreaWithCity:self.cityArray[indexPath.row]];
        }else if (indexPath.section == 2) {
            self.thirdLevelSelectedIndex = indexPath.row;
        }else if (indexPath.section == 3) {
            self.fourthLevelSelectedIndex = indexPath.row;
        }
        [self.collectionView reloadData];
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        FilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.title = @"省";
        }else if (indexPath.section == 1) {
            headerView.title = @"地市";
        }else if (indexPath.section == 2){
            headerView.title = @"区县";
        }else if (indexPath.section == 3){
            headerView.title = @"时间";
        }
        return headerView;
    }else if (indexPath.section == 3) {
        CustomTimeSettingView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CustomTimeSettingView" forIndexPath:indexPath];
        footer.hidden = self.fourthLevelSelectedIndex != self.timeArray.count-1;
        self.timeSettingView = footer;
        return footer;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return CGSizeMake(SCREEN_WIDTH, 120);
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if (self.secondLevelSelectedIndex == -1) {
            return CGSizeZero;
        }
    }
    return CGSizeMake(SCREEN_WIDTH, 50);
}

@end

//
//  TrainingProfileViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TrainingProfileViewController.h"
#import "TrainingProfileHeaderView.h"
#import "TitleHeaderView.h"
#import "TrainingProjectCell.h"
#import "ProjectLevelDistributingCell.h"
#import "ProjectAreaDistributingCell.h"
#import "TrainingProjectDetailViewController.h"
#import "ProjectFilterViewController.h"
#import "YXDrawerController.h"
#import "GetSummaryRequest.h"
#import "ErrorView.h"
#import "MJRefresh.h"

@interface TrainingProfileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TrainingProfileHeaderView *headerView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) GetSummaryRequest *getSummaryRequest;
@property (nonatomic, strong) GetSummaryRequestItem *requestItem;
@property (nonatomic, strong) Area *province;
@property (nonatomic, strong) Area *city;
@property (nonatomic, strong) Area *district;
@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@end

@implementation TrainingProfileViewController
- (void)dealloc {
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"培训概况";
    if ([[YXDrawerController drawer].paneViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)[YXDrawerController drawer].paneViewController;
        if (navi.viewControllers[0] == self) {
            WEAK_SELF
            [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
                STRONG_SELF
                [YXDrawerController showDrawer];
            }];
        }
    }    
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"筛选" action:^{
        STRONG_SELF
        ProjectFilterViewController *vc = [[ProjectFilterViewController alloc]init];
        vc.chooseArray = @[self.province?:@(0),self.city?:@(0),self.district?:@(0),@(self.timeIndex),self.startTime?:@"",self.endTime?:@""];
        WEAK_SELF
        [vc setSelectBlock:^(Area *province, Area *city, Area *district, NSInteger timeIndex, NSString *startTime, NSString *endTime)  {
            STRONG_SELF
            self.province = province;
            self.city = city;
            self.district = district;
            self.timeIndex = timeIndex;
            self.startTime = startTime;
            self.endTime = endTime;
            [self requestSummary];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self setupUI];
    [self requestSummary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 45;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[TrainingProjectCell class] forCellReuseIdentifier:@"TrainingProjectCell"];
    [self.tableView registerClass:[ProjectLevelDistributingCell class] forCellReuseIdentifier:@"ProjectLevelDistributingCell"];
    [self.tableView registerClass:[ProjectAreaDistributingCell class] forCellReuseIdentifier:@"ProjectAreaDistributingCell"];
    [self.tableView registerClass:[TitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"TitleHeaderView"];
    
    self.headerView = [[TrainingProfileHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 324)];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.hidden = YES;
    
    WEAK_SELF
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestSummary];
    };

    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestSummary];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

- (void)requestSummary {
    [self.view nyx_startLoading];
    [self.getSummaryRequest stopRequest];
    self.getSummaryRequest = [[GetSummaryRequest alloc]init];
    GetUserPlatformRequestItem_platformInfos *plat = [UserManager sharedInstance].userModel.platformRequestItem.data.platformInfos.firstObject;
    self.getSummaryRequest.platId = plat.platformId;
    self.getSummaryRequest.provinceId = self.province.areaID;
    self.getSummaryRequest.cityId = self.city.areaID;
    self.getSummaryRequest.districtId = self.district.areaID;
    self.getSummaryRequest.startTime = self.startTime;
    self.getSummaryRequest.endTime = self.endTime;
    if (!self.province) {
        self.getSummaryRequest.groupByType = @"2";
    }else if (!self.city) {
        self.getSummaryRequest.groupByType = @"3";
    }else {
        self.getSummaryRequest.groupByType = @"4";
    }
    WEAK_SELF
    [self.getSummaryRequest startRequestWithRetClass:[GetSummaryRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.header endRefreshing];
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetSummaryRequestItem *item = (GetSummaryRequestItem *)retItem;
        self.requestItem = item;
        self.headerView.data = item.data.platformStatisticInfo;
        [self.headerView updateWithPtocince:self.province city:self.city district:self.district];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        return 1;
    }
    if (section == 3) {
        return self.requestItem.data.platformStatisticInfo.projectSatisfiedTop.count;
    }else {
        return self.requestItem.data.platformStatisticInfo.onGoingprojectList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProjectLevelDistributingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectLevelDistributingCell"];
        cell.dataArray = self.requestItem.data.platformStatisticInfo.projectStatisticInfoListLevel;
        return cell;
    } else if (indexPath.section == 1) {
        ProjectLevelDistributingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectLevelDistributingCell"];
        cell.dataArray = self.requestItem.data.platformStatisticInfo.projectStatisticInfoListType;
        return cell;
    }else if (indexPath.section == 2) {
        ProjectAreaDistributingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectAreaDistributingCell"];
        cell.groupByType = self.requestItem.data.platformStatisticInfo.groupByType;
        cell.dataArray = self.requestItem.data.platformStatisticInfo.projectStatisticInfoListArea;
        return cell;
    }else if (indexPath.section == 3) {
        TrainingProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainingProjectCell"];
        GetSummaryRequestItem_projectSatisfiedTop *top = self.requestItem.data.platformStatisticInfo.projectSatisfiedTop[indexPath.row];
        [cell reloadTraining:top.project.projectName percent:[NSString stringWithFormat:@"%.0f%%",[top.percent floatValue] * 100] level:indexPath.row + 1];
        cell.lineHidden = indexPath.row==self.requestItem.data.platformStatisticInfo.projectSatisfiedTop.count-1;
        return cell;
    }else {
        TrainingProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainingProjectCell"];
        GetSummaryRequestItem_onGoingprojectList *ongoing = self.requestItem.data.platformStatisticInfo.onGoingprojectList[indexPath.row];
        cell.name = ongoing.projectName;
        cell.lineHidden = indexPath.row==self.requestItem.data.platformStatisticInfo.onGoingprojectList.count-1;
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TitleHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TitleHeaderView"];
    if (section == 0) {
        header.title = @"项目级别分布";
    }else if (section == 1) {
        header.title = @"项目类型分布";
    }else if (section == 2) {
        header.title = @"项目地区分布";
    }else if (section == 3) {
        header.title = @"项目满意度TOP5";
    }else if (section == 4) {
        header.title = @"进行中的项目";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 380;
    }else if (indexPath.section == 1) {
        return 380;
    }else if (indexPath.section == 2) {
        return 350;
    }else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 3 && indexPath.section != 4) {
        return;
    }
    TrainingProjectDetailViewController *vc = [[TrainingProjectDetailViewController alloc]init];
    if (indexPath.section == 3) {
        GetSummaryRequestItem_onGoingprojectList *ongoing = self.requestItem.data.platformStatisticInfo.onGoingprojectList[indexPath.row];
        vc.projectId = ongoing.projectID;
    }else if (indexPath.section == 4) {
        GetSummaryRequestItem_projectSatisfiedTop *top = self.requestItem.data.platformStatisticInfo.projectSatisfiedTop[indexPath.row];
        vc.projectId = top.projectId;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end

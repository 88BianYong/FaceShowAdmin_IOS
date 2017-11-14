//
//  MainPageViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageViewController.h"
#import "YXDrawerController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "MainPageTopView.h"
#import "MainPageScrollView.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "MainPageTableHeaderView.h"
#import "CourseListCell.h"
#import "CourseListHeaderView.h"
#import "ClazsGetClazsRequest.h"
#import "MainPageFooterView.h"
#import "TodaySignInsCell.h"
#import "SignInListViewController.h"
#import "MainPageDetailViewController.h"
#import "NoticeListViewController.h"
#import "ContactsViewController.h"
#import "ResourceManagerViewController.h"
#import "ScheduleDetailViewController.h"
#import "ScheduleDetailRequest.h"
@interface MainPageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) ClazsGetClazsRequest *clazsRequest;
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data *itemData;
@property (nonatomic, strong) ScheduleDetailRequest *detailRequest;

@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;

@property (nonatomic, strong) MainPageTopView *topView;
@property (nonatomic, strong) MainPageScrollView *scrollView;
@property (nonatomic, strong) MainPageTableHeaderView *headerView;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
        STRONG_SELF
        [YXDrawerController showDrawer];
    }];
    self.navigationItem.title = @"研修宝";
    [self setupUI];
    [self setupLayout];
    [self requestMainPageClassInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setItemData:(ClazsGetClazsRequestItem_Data *)itemData {
    _itemData = itemData;
    self.topView.hidden = NO;
    self.topView.projectInfo = _itemData.projectInfo;
    self.topView.clazsInfo = _itemData.clazsInfo;
    self.topView.clazsStatistic = _itemData.clazsStatisticView;
    self.headerView.clazsStatistic = _itemData.clazsStatisticView;
    self.scrollView.hidden = NO;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}
#pragma mark - setupUI
- (void)setupUI {
    self.topView = [[MainPageTopView alloc] init];
    WEAK_SELF
    self.topView.mainPagePushDetailBlock = ^{
        STRONG_SELF
        MainPageDetailViewController *VC = [[MainPageDetailViewController alloc] init];
        VC.itemData = self.itemData;
        [self.navigationController pushViewController:VC animated:YES];
    };
    self.topView.hidden = YES;
    [self.view addSubview:self.topView];
    self.scrollView = [[MainPageScrollView alloc] initWithFrame:CGRectZero];
    [self.scrollView setActionBlock:^(MainPagePushType type) {
        STRONG_SELF
        if (type == MainPagePushType_Check) {
            SignInListViewController *vc = [[SignInListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(type == MainPagePushType_Notice){
            NoticeListViewController *VC = [[NoticeListViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (type == MainPagePushType_Contacts) {
            ContactsViewController *vc = [[ContactsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (type == MainPagePushType_Resources) {
            ResourceManagerViewController *VC = [[ResourceManagerViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }else if (type == MainPagePushType_Schedule) {
            [self requestForScheduleDetail];
        }
    }];
    self.scrollView.hidden = YES;
    [self.view addSubview:self.scrollView];
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[TodaySignInsCell class] forCellReuseIdentifier:@"TodaySignInsCell"];
    [self.tableView registerClass:[CourseListCell class] forCellReuseIdentifier:@"CourseListCell"];
    [self.tableView registerClass:[MainPageFooterView class] forHeaderFooterViewReuseIdentifier:@"MainPageFooterView"];
    [self.tableView registerClass:[CourseListHeaderView class] forHeaderFooterViewReuseIdentifier:@"CourseListHeaderView"];
    [self.view addSubview:self.tableView];
    self.headerView = [[MainPageTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85.0f)];
    self.tableView.tableHeaderView = self.headerView;
    self.emptyView = [[EmptyView alloc] init];
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    self.errorView = [[ErrorView alloc] init];
    self.errorView.hidden = YES;
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestMainPageClassInfo];
    }];
    [self.view addSubview:self.errorView];
}
- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(135.0f + 40.0f);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_offset(100.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scrollView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - request
- (void)requestMainPageClassInfo {
    [self.clazsRequest stopRequest];
    self.clazsRequest = [[ClazsGetClazsRequest alloc] init];
    self.clazsRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.clazsRequest startRequestWithRetClass:[ClazsGetClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        ClazsGetClazsRequestItem *item = retItem;
        if (item.data.projectInfo == nil) {
            self.emptyView.hidden = NO;
            return;
        }
        [UserManager sharedInstance].userModel.currentProject = item.data.projectInfo;
        [[UserManager sharedInstance] saveData];
        self.itemData = item.data;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.itemData.todaySignIns.count;
    }else {
        return self.itemData.todayCourses.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TodaySignInsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodaySignInsCell" forIndexPath:indexPath];
        cell.todySignIns = self.itemData.todaySignIns[indexPath.row];
        return cell;
    }else {
        CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseListCell"];
        cell.item = self.itemData.todayCourses[indexPath.row];
        return cell;
    }

    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MainPageFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MainPageFooterView"];
    if (section == 0) {
        footerView.title = @"今日无签到";
    }else {
        footerView.title = @"今日无课程";
    }
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.itemData.todaySignIns.count == 0 ? 70.0f : 0.000001f;
    }else {
        return self.itemData.todayCourses.count == 0 ? 70.0f : 0.000001f;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseListHeaderView"];
    if (section == 0) {
        header.title = @"今日签到";
    }else {
        header.title = @"今日课程";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70.0f;
    }else {
        return 137.0f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc] init];
//    GetCourseListRequestItem_courses *courses = self.listRequestItem.data.courses[indexPath.section];
//    GetCourseListRequestItem_coursesList *course = courses.coursesList[indexPath.row];
//    courseDetailVC.courseId = course.courseId;
//    [self.navigationController pushViewController:courseDetailVC animated:YES];
}
- (void)requestForScheduleDetail {
    self.detailRequest = [[ScheduleDetailRequest alloc] init];
    self.detailRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.detailRequest startRequestWithRetClass:[ScheduleDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }else {
            ScheduleDetailRequestItem *item = retItem;
            ScheduleDetailViewController *VC = [[ScheduleDetailViewController alloc] init];
            if (item.data.schedules.elements.count > 0) {
                VC.element = item.data.schedules.elements[0];
            }
            [self.navigationController pushViewController:VC animated:item.data.schedules.elements.count > 0];
        }
    }];
    
}

@end

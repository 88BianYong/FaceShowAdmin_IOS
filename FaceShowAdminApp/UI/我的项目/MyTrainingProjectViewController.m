//
//  MyTrainingProjectViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MyTrainingProjectViewController.h"
#import "ProjectDetailCell.h"
#import "TitleHeaderView.h"
#import "TrainingProjectDetailViewController.h"
#import "YXDrawerController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "MJRefresh.h"
#import "GetMyProjectsRequest.h"

@interface MyTrainingProjectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *groupArray;
@property (nonatomic, strong) GetMyProjectsRequest *projectRequest;
@end

@implementation MyTrainingProjectViewController
- (void)dealloc {
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的项目";
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
    self.groupArray = [NSMutableArray array];
    [self setupUI];
    [self requestMyProjects];
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
    [self.tableView registerClass:[ProjectDetailCell class] forCellReuseIdentifier:@"ProjectDetailCell"];
    [self.tableView registerClass:[TitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"TitleHeaderView"];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.tableHeaderView = headerView;
    
    WEAK_SELF
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestMyProjects];
    };
    
    self.emptyView = [[EmptyView alloc]init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestMyProjects];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView.hidden = YES;
}

- (void)requestMyProjects {
    [self.view nyx_startLoading];
    [self.projectRequest stopRequest];
    self.projectRequest = [[GetMyProjectsRequest alloc]init];
    GetUserPlatformRequestItem_platformInfos *plat = [UserManager sharedInstance].userModel.platformRequestItem.data.platformInfos.firstObject;
    self.projectRequest.platId = plat.platformId;
#warning 先写死101
    self.projectRequest.platId = @"101";
    WEAK_SELF
    [self.projectRequest startRequestWithRetClass:[GetMyProjectsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.header endRefreshing];
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetMyProjectsRequestItem *item = (GetMyProjectsRequestItem *)retItem;
        if (item.data.projectGoingCountes.count == 0 &&
            item.data.projectNoStartCountes.count == 0 &&
            item.data.projectFinishedCountes.count == 0) {
            self.emptyView.hidden = NO;
            return;
        }
        [self.groupArray addObject:item.data.projectGoingCountes];
        [self.groupArray addObject:item.data.projectFinishedCountes];
        [self.groupArray addObject:item.data.projectNoStartCountes];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupArray[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectDetailCell"];
    cell.data = self.groupArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.type = ProjectGroup_InProgress;
    }else if (indexPath.section == 1) {
        cell.type = ProjectGroup_Complete;
    }else {
        cell.type = ProjectGroup_NotStarted;
    }
    return cell;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 111;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrainingProjectDetailViewController *vc = [[TrainingProjectDetailViewController alloc]init];
    GetMyProjectsRequestItem_project *project = self.groupArray[indexPath.section][indexPath.row];
    vc.projectId = project.projectId;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

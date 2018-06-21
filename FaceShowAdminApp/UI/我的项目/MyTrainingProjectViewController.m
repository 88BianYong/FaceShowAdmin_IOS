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

@interface ProjectGroup :NSObject
@property (nonatomic, assign) ProjectGroupType type;
@property (nonatomic, assign) NSInteger count;
@end

@implementation ProjectGroup
@end

@interface MyTrainingProjectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ProjectGroup *> *groupArray;
@end

@implementation MyTrainingProjectViewController

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
    ProjectGroup *g1 = [[ProjectGroup alloc]init];
    g1.type = ProjectGroup_InProgress;
    g1.count = 3;
    ProjectGroup *g2 = [[ProjectGroup alloc]init];
    g2.type = ProjectGroup_Complete;
    g2.count = 1;
    ProjectGroup *g3 = [[ProjectGroup alloc]init];
    g3.type = ProjectGroup_NotStarted;
    g3.count = 1;
    [self.groupArray addObjectsFromArray:@[g1,g2,g3]];
    [self setupUI];
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
    ProjectGroup *group = self.groupArray[indexPath.section];
    cell.type = group.type;
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TitleHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TitleHeaderView"];
    ProjectGroup *group = self.groupArray[section];
    if (group.type == ProjectGroup_InProgress) {
        header.title = nil;
    }else if (group.type == ProjectGroup_Complete) {
        header.title = @"已完成项目";
    }else if (group.type == ProjectGroup_NotStarted) {
        header.title = @"未开始项目";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ProjectGroup *group = self.groupArray[section];
    if (group.type == ProjectGroup_InProgress) {
        return 0;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectGroup *group = self.groupArray[indexPath.section];
    if (indexPath.row == group.count-1) {
        return 106;
    }
    return 111;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrainingProjectDetailViewController *vc = [[TrainingProjectDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

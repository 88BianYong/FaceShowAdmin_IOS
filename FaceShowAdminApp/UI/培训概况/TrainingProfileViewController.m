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

@interface TrainingProfileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TrainingProfileHeaderView *headerView;
@end

@implementation TrainingProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"培训概况";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"筛选" action:^{
        STRONG_SELF
    }];
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
    [self.tableView registerClass:[TrainingProjectCell class] forCellReuseIdentifier:@"TrainingProjectCell"];
    [self.tableView registerClass:[ProjectLevelDistributingCell class] forCellReuseIdentifier:@"ProjectLevelDistributingCell"];
    [self.tableView registerClass:[ProjectAreaDistributingCell class] forCellReuseIdentifier:@"ProjectAreaDistributingCell"];
    [self.tableView registerClass:[TitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"TitleHeaderView"];
    
    self.headerView = [[TrainingProfileHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 324)];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProjectLevelDistributingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectLevelDistributingCell"];
        return cell;
    }else if (indexPath.section == 1) {
        ProjectAreaDistributingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectAreaDistributingCell"];
        return cell;
    }else {
        TrainingProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainingProjectCell"];
        cell.name = @"2017测试项目";
        cell.lineHidden = indexPath.row==4;
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TitleHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TitleHeaderView"];
    if (section == 0) {
        header.title = @"项目级别分布";
    }else if (section == 1) {
        header.title = @"项目地区分布";
    }else if (section == 2) {
        header.title = @"进行中的项目";
    }else if (section == 3) {
        header.title = @"项目满意度TOP5";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 380;
    }else if (indexPath.section == 1) {
        return 350;
    }else {
        return 50;
    }
}
@end

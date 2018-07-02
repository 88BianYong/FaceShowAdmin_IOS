//
//  ProjectsByTypeViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/8/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectsByTypeViewController.h"
#import "ProjectDetailCell.h"
#import "TitleHeaderView.h"
#import "TrainingProjectDetailViewController.h"
#import "YXDrawerController.h"
#import "ProjectsByTypeFetcher.h"
#import "ProjectListRequest.h"
@interface ProjectsByTypeViewController ()
@end

@implementation ProjectsByTypeViewController
- (void)viewDidLoad {
    ProjectsByTypeFetcher *fetcher = [[ProjectsByTypeFetcher alloc]init];
    fetcher.startTime = self.startTime;
    fetcher.endTime = self.endTime;
    
    fetcher.projectQueryType = self.projectQueryType;
    fetcher.projectQueryTypeValue = self.projectQueryTypeValue;
    
    fetcher.provinceId = self.provinceId;
    fetcher.cityId = self.cityId;
    fetcher.districtId = self.districtId;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"项目列表";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ProjectDetailCell class] forCellReuseIdentifier:@"ProjectDetailCell"];
    [self.tableView registerClass:[TitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"TitleHeaderView"];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectDetailCell"];
    cell.data = self.dataArray[indexPath.row];
    cell.type = ProjectGroup_InProgress;
    return cell;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 111;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrainingProjectDetailViewController *vc = [[TrainingProjectDetailViewController alloc]init];
    ProjectListRequestItem_elements *project = self.dataArray[indexPath.row];
    vc.projectId = project.elementID;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

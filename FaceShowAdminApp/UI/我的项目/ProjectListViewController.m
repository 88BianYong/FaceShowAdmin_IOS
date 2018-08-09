//
//  ProjectListViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectListViewController.h"
#import "ProjectDetailCell.h"
#import "TitleHeaderView.h"
#import "TrainingProjectDetailViewController.h"
#import "YXDrawerController.h"
#import "ProjectListFetcher.h"
#import "ProjectListRequest.h"

@interface ProjectListViewController ()
@end

@implementation ProjectListViewController

- (void)viewDidLoad {
    ProjectListFetcher *fetcher = [[ProjectListFetcher alloc]init];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"项目列表";
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

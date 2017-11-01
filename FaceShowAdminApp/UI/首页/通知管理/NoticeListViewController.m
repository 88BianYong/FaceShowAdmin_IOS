//
//  NoticeListViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeListFetcher.h"
#import "NoticeListCell.h"
#import "FSDefaultHeaderFooterView.h"
#import "NoticeDetailViewController.h"
@interface NoticeListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString *studentNum;
@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    NoticeListFetcher *fetcher = [[NoticeListFetcher alloc] init];
    fetcher.pagesize = 20;
    fetcher.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    WEAK_SELF
    fetcher.noticeStudentNum = ^(NSString *number) {
        STRONG_SELF
        self.studentNum = number;
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"通知管理";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    [self.tableView registerClass:[NoticeListCell class] forCellReuseIdentifier:@"NoticeListCell"];
    [self setupNavRightView];
}
- (void)setupLayout {
    
}
- (void)setupNavRightView {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 75, 30);
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-正常态"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-点击态"] forState:UIControlStateHighlighted];
    navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -24, 0, 24);
    navRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 38, 0, -38);
    WEAK_SELF
    [[navRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        
    }];
    [self nyx_setupRightWithCustomView:navRightBtn];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count > 0 ? 1 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeListCell" forIndexPath:indexPath];
    [cell reloadCell:self.dataArray[indexPath.row] withStudentNum:self.studentNum];
    return cell;
}
#pragma mark - UITableViewDataScore
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NoticeDetailViewController *VC = [[NoticeDetailViewController alloc] init];
    VC.element = self.dataArray[indexPath.row];
    VC.studentNum = self.studentNum;
    [self.navigationController pushViewController:VC animated:YES];
}

@end

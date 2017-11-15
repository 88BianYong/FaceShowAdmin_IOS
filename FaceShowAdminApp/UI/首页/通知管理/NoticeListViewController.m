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
#import "NoticeSaveViewController.h"
@interface NoticeListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString *studentNum;
@end

@implementation NoticeListViewController
- (void)dealloc {
    DDLogDebug(@"release========>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    self.studentNum = @"0";
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
    self.emptyView.title = @"尚未发布通知";
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
    //15901259665
}
- (void)setupNavRightView {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 65, 30);
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"发布通知icon正常态"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"发布通知icon点击态"] forState:UIControlStateHighlighted];
    [navRightBtn.titleLabel sizeToFit];
    navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30-5, 0, 30+5);
    navRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, navRightBtn.titleLabel.width+5, 0, -navRightBtn.titleLabel.width-5);
    WEAK_SELF
    [[navRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [TalkingData trackEvent:@"发布通知"];
        NoticeSaveViewController *VC = [[NoticeSaveViewController alloc] init];
        FSNavigationController *nav = [[FSNavigationController alloc] initWithRootViewController:VC];
        VC.noticeSaveBlock = ^(NoticeListRequestItem_Data_NoticeInfos_Elements *element) {
            STRONG_SELF
            [self.dataArray insertObject:element atIndex:0];
            self.emptyView.hidden = YES;
            self.errorView.hidden = YES;
            [self.tableView reloadData];
        };
        [[self nyx_visibleViewController] presentViewController:nav animated:YES completion:^{
        }];
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
    WEAK_SELF
    VC.noticeDetailDeleteBlock = ^{
        STRONG_SELF
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        self.emptyView.hidden = self.dataArray.count != 0 ? YES : NO;
    };
    [self.navigationController pushViewController:VC animated:YES];
}

@end

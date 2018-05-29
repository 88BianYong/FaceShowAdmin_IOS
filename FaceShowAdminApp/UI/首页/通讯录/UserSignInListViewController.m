//
//  UserSignInListViewController.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignInListViewController.h"
#import "UserSignInRecordListFetcher.h"
#import "UserSignInListCell.h"
#import "AlertView.h"
#import "SignInDelayView.h"
#import "ReplenishSignInRequest.h"
#import "UnsignedMemberListViewController.h"

@interface UserSignInListViewController ()
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) ReplenishSignInRequest *request;
@end

@implementation UserSignInListViewController

- (void)viewDidLoad {
    UserSignInRecordListFetcher *fetcher = [[UserSignInRecordListFetcher alloc] init];
    fetcher.userId = self.userId;
    self.dataFetcher = fetcher;
    [super viewDidLoad];

    self.navigationItem.title = @"签到记录";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 71;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 5)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[UserSignInListCell class] forCellReuseIdentifier:@"UserSignInListCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSignInListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserSignInListCell"];
    SignInListRequestItem_signIns *data = self.dataArray[indexPath.row];
    cell.data = data;
    WEAK_SELF
    cell.signInBtnBlock = ^{
        STRONG_SELF
        [TalkingData trackEvent:@"个人签到记录补签"];
        [self showAlertWithData:data];
    };
    return cell;
}

- (void)showAlertWithData:(SignInListRequestItem_signIns *)data {
    SignInDelayView *settingView = [[SignInDelayView alloc]init];
    settingView.name = self.userName;
    WEAK_SELF
    [settingView setConfirmBlock:^(NSString *result){
        STRONG_SELF
        [self replenishSignInWithData:data time:result];
        [self.alertView hide];
    }];
    self.alertView = [[AlertView alloc]init];
    self.alertView.contentView = settingView;
    self.alertView.hideWhenMaskClicked = YES;
    [self.alertView showWithLayout:^(AlertView *view) {
        view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        [UIView animateWithDuration:0.3 animations:^{
            view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
        }];
    }];
}

- (void)replenishSignInWithData:(SignInListRequestItem_signIns *)data time:(NSString *)time {
    [self.request stopRequest];
    self.request = [[ReplenishSignInRequest alloc]init];
    self.request.stepId = data.stepId;
    self.request.userId = self.userId;
    self.request.signInTime = time;
    if ([data.signInType isEqualToString:@"位置签到"]) {
        self.request.signInPlace = data.signInPlace;
    }
    [self.parentViewController.view nyx_startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.parentViewController.view nyx_stopLoading];
        if (error) {
            [self.parentViewController.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self firstPageFetch];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReplenishSignInDidSuccessNotification object:nil];
    }];
}

@end

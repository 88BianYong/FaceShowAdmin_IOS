//
//  UnsignedMemberListViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UnsignedMemberListViewController.h"
#import "UserUnsignedCell.h"
#import "UserSignInListFetcher.h"
#import "SignInDelayView.h"
#import "AlertView.h"
#import "ReplenishSignInRequest.h"

NSString * const kReplenishSignInDidSuccessNotification = @"kReplenishSignInDidSuccessNotification";

@interface UnsignedMemberListViewController ()
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) ReplenishSignInRequest *request;
@end

@implementation UnsignedMemberListViewController

- (void)viewDidLoad {
    UserSignInListFetcher *fetcher = [[UserSignInListFetcher alloc]init];
    fetcher.stepId = self.stepId;
    fetcher.status = @"0";
    WEAK_SELF
    [fetcher setNoMoreBlock:^{
        STRONG_SELF
        [self.view performSelector:@selector(nyx_showToast:) withObject:@"暂无更多" afterDelay:1];
    }];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 51;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UserUnsignedCell class] forCellReuseIdentifier:@"UserUnsignedCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserUnsignedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserUnsignedCell"];
    cell.data = self.dataArray[indexPath.row];
    WEAK_SELF
    [cell setSignBlock:^{
        STRONG_SELF
        [self showAlertWithElement:self.dataArray[indexPath.row]];
    }];
    return cell;
}

- (void)showAlertWithElement:(UserSignInListRequestItem_elements *)element {
    SignInDelayView *settingView = [[SignInDelayView alloc]init];
    settingView.name = element.userName;
    WEAK_SELF
    [settingView setConfirmBlock:^(NSString *result){
        STRONG_SELF
        [TalkingData trackEvent:@"签到详情补签"];
        [self replenishSignInWithElement:element time:result];
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

- (void)replenishSignInWithElement:(UserSignInListRequestItem_elements *)element time:(NSString *)time{
    [self.request stopRequest];
    self.request = [[ReplenishSignInRequest alloc]init];
    self.request.stepId = self.stepId;
    self.request.userId = element.userId;
    self.request.signInTime = time;
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

//
//  SignedMemberListViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignedMemberListViewController.h"
#import "UserSignInListFetcher.h"
#import "UserSignedCell.h"
#import "UnsignedMemberListViewController.h"

@interface SignedMemberListViewController ()

@end

@implementation SignedMemberListViewController

- (void)viewDidLoad {
    UserSignInListFetcher *fetcher = [[UserSignInListFetcher alloc]init];
    fetcher.stepId = self.stepId;
    fetcher.status = @"1";
    WEAK_SELF
    [fetcher setNoMoreBlock:^{
        STRONG_SELF
        [self.view performSelector:@selector(nyx_showToast:) withObject:@"暂无更多" afterDelay:1];
    }];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kReplenishSignInDidSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self firstPageFetch];
    }];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 51;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UserSignedCell class] forCellReuseIdentifier:@"UserSignedCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSignedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserSignedCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

@end

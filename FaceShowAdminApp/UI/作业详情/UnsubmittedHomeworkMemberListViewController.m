//
//  UnsubmittedHomeworkMemberListViewController.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UnsubmittedHomeworkMemberListViewController.h"
#import "MemberHomeworkCell.h"
#import "MemberHomeworkDetailViewController.h"
#import "UserHomeworkFetcher.h"

@interface UnsubmittedHomeworkMemberListViewController ()

@end

@implementation UnsubmittedHomeworkMemberListViewController

- (void)viewDidLoad {
    UserHomeworkFetcher *fetcher = [[UserHomeworkFetcher alloc] init];
    fetcher.stepId = self.stepId;
    fetcher.isFinished = @"0";
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self.view nyx_stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 71;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MemberHomeworkCell class] forCellReuseIdentifier:@"MemberHomeworkCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberHomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberHomeworkCell"];
    cell.element = self.dataArray[indexPath.row];
    cell.isFinished = @"0";
    return cell;
}

@end


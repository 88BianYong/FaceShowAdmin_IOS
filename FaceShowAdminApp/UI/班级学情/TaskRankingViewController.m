//
//  TaskRankingViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskRankingViewController.h"
#import "TaskRankingFetcher.h"
#import "TaskRankingCell.h"
#import "TaskAverageView.h"
#import "ScoreDetialViewController.h"
#import "GetUserTasksProgressRankRequest.h"

@interface TaskRankingViewController ()
@property(nonatomic, strong) TaskAverageView *topView;
@end

@implementation TaskRankingViewController

- (void)viewDidLoad {
    TaskRankingFetcher *fetcher = [[TaskRankingFetcher alloc] init];
    fetcher.clazzId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.dataFetcher = fetcher;
    WEAK_SELF
    [fetcher setFinishBlock:^(NSString *avargeValue) {
        STRONG_SELF
        self.topView.averageValue = avargeValue;
    }];
    self.topView = [[TaskAverageView alloc]init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(130);
    }];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.estimatedRowHeight = 0;
    [self.tableView registerClass:[TaskRankingCell class] forCellReuseIdentifier:@"TaskRankingCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskRankingCell"];
    cell.element = self.dataArray[indexPath.row];
    if (indexPath.row == self.dataArray.count - 1) {
        cell.isShowLine = NO;
    }else {
        cell.isShowLine = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GetUserTasksProgressRankRequestItem_element *element = self.dataArray[indexPath.row];
    ScoreDetialViewController *vc = [[ScoreDetialViewController alloc]init];
    vc.userId = element.userId;
    vc.title = element.userName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RefreshDelegate
- (void)refreshUI {
}
@end

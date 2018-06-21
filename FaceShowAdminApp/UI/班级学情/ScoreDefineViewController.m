//
//  ScoreDefineViewController.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScoreDefineViewController.h"
#import "ScoreEditViewController.h"
#import "ScoreSettingCell.h"
#import "GetClazsScoreConfigRequest.h"
#import "ErrorView.h"

@interface ScoreDefineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) GetClazsScoreConfigRequest *request;
@property (nonatomic, strong) GetClazsScoreConfigRequestItem_data *data;
@end

@implementation ScoreDefineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分设置";
    [self setupUI];
    [self requestScoreConfig];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 45;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[ScoreSettingCell class] forCellReuseIdentifier:@"ScoreSettingCell"];
    
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestScoreConfig];
    }];
}

- (void)requestScoreConfig {
    [self.request stopRequest];
    self.request = [[GetClazsScoreConfigRequest alloc]init];
    self.request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[GetClazsScoreConfigRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        GetClazsScoreConfigRequestItem *item = (GetClazsScoreConfigRequestItem *)retItem;
        [self.errorView removeFromSuperview];
        self.data = item.data;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.configItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreSettingCell"];
    cell.item = self.data.configItems[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreEditViewController *vc = [[ScoreEditViewController alloc]init];
    vc.data = self.data;
    vc.currentItem = self.data.configItems[indexPath.row];
    WEAK_SELF
    [vc setFinishBlock:^{
        STRONG_SELF
        [self requestScoreConfig];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

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

@interface ScoreDefineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *editButton;
@end

@implementation ScoreDefineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分设置";
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [self setupNavView];
    
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
}

- (void)setupNavView {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if ([rightButton.titleLabel.text isEqualToString:@"编辑"]) {
            [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        }else {
            [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
    }];
    self.editButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreSettingCell"];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreEditViewController *vc = [[ScoreEditViewController alloc]init];
    vc.scoreName = @"评价";
    vc.score = @"16";
    [self.navigationController pushViewController:vc animated:YES];
}

@end

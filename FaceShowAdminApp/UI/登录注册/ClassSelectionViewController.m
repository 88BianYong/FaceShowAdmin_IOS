//
//  ClassSelectionViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassSelectionViewController.h"
#import "ClassListCell.h"

@interface ClassSelectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) ClassListRequestItem_clazsInfos *selectedClass;
@end

@implementation ClassSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupNav
- (void)setupNav {
    self.title = @"选择班级";
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navRightBtn.frame = CGRectMake(0, 0, 40, 30);
    self.navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navRightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.navRightBtn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.navRightBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.navRightBtn addTarget:self action:@selector(navRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navRightBtn.enabled = !isEmpty(self.selectedClass);
    [self nyx_setupRightWithCustomView:self.navRightBtn];
}

- (void)navRightBtnAction:(UIButton *)sender {
    [UserManager sharedInstance].userModel.currentClass = self.selectedClass;
    [[UserManager sharedInstance] saveData];
    [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableview = [[UITableView alloc]init];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableview.allowsMultipleSelection = NO;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableview registerClass:[ClassListCell class] forCellReuseIdentifier:@"ClassListCell"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UserManager sharedInstance].userModel.clazsInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassListCell"];
    ClassListRequestItem_clazsInfos *info = [UserManager sharedInstance].userModel.clazsInfos[indexPath.row];
    cell.classInfo = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedClass = [UserManager sharedInstance].userModel.clazsInfos[indexPath.row];
    self.navRightBtn.enabled = !isEmpty(self.selectedClass);
}

@end

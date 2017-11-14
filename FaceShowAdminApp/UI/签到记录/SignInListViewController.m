//
//  SignInListViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInListViewController.h"
#import "SignInListFetcher.h"
#import "SignInListCell.h"
#import "CreateSignInViewController.h"
#import "SignInDetailViewController.h"
#import "UnsignedMemberListViewController.h"

@interface SignInListViewController ()

@end

@implementation SignInListViewController

- (void)viewDidLoad {
    self.dataFetcher = [[SignInListFetcher alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"签到记录";
    [self nyx_setupRightWithCustomView:[self signInCreateButton]];
    self.emptyView.title = @"尚未设置签到";
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

- (UIButton *)signInCreateButton {
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:@"新建" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:15];
    [b setImage:[UIImage imageNamed:@"添加按钮正常态"] forState:UIControlStateNormal];
    [b setImage:[UIImage imageNamed:@"添加按钮点击态"] forState:UIControlStateHighlighted];
    [b.titleLabel sizeToFit];
    b.titleEdgeInsets = UIEdgeInsetsMake(0, -30-5, 0, 30+5);
    b.imageEdgeInsets = UIEdgeInsetsMake(0, b.titleLabel.width+5, 0, -b.titleLabel.width-5);
    [b addTarget:self action:@selector(createSignIn) forControlEvents:UIControlEventTouchUpInside];
    b.frame = CGRectMake(0, 0, 77, 30);
    return b;
}

- (void)createSignIn {
    CreateSignInViewController *vc = [[CreateSignInViewController alloc]init];
    WEAK_SELF
    [vc setComleteBlock:^{
        STRONG_SELF
        [self firstPageFetch];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 71;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 5)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[SignInListCell class] forCellReuseIdentifier:@"SignInListCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignInListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignInListCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SignInDetailViewController *vc = [[SignInDetailViewController alloc]init];
    vc.data = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

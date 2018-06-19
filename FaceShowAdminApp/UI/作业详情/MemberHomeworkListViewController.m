//
//  MemberHomeworkListViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MemberHomeworkListViewController.h"
#import "MemberHomeworkCell.h"
#import "MemberHomeworkDetailViewController.h"

@interface MemberHomeworkListViewController ()

@end

@implementation MemberHomeworkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self.view nyx_stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)firstPageFetch {
    
}
- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 71;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MemberHomeworkCell class] forCellReuseIdentifier:@"MemberHomeworkCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberHomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberHomeworkCell"];
//    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberHomeworkDetailViewController *vc = [[MemberHomeworkDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

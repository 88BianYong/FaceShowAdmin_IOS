//
//  CourseResourceViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseResourceViewController.h"
#import "CourseResourceFetcher.h"
#import "CourseResourceCell.h"
#import "ResourceDisplayViewController.h"

@interface CourseResourceViewController ()

@end

@implementation CourseResourceViewController

- (void)viewDidLoad {
    CourseResourceFetcher *fetcher = [[CourseResourceFetcher alloc]init];
    fetcher.courseId = self.courseId;
    self.dataFetcher = fetcher;
    self.bNeedHeader = NO;
    self.bNeedFooter = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationController.navigationBarHidden) {
        return;
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 71;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseResourceCell class] forCellReuseIdentifier:@"CourseResourceCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseResourceCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ResourceDisplayViewController *vc = [[ResourceDisplayViewController alloc]init];
    CourseResourceRequestItem_elements *data = self.dataArray[indexPath.row];
    vc.urlString = data.url;
    vc.name = data.resName;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

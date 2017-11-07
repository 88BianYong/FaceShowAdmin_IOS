//
//  QuestionUserListViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionUserListViewController.h"
#import "ClassUserQuestionFetcher.h"
#import "QuestionUserCell.h"

@interface QuestionUserListViewController ()

@end

@implementation QuestionUserListViewController

- (void)viewDidLoad {
    ClassUserQuestionFetcher *fetcher = [[ClassUserQuestionFetcher alloc]init];
    fetcher.stepId = self.stepId;
    fetcher.status = self.status;
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
    [self.tableView registerClass:[QuestionUserCell class] forCellReuseIdentifier:@"QuestionUserCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionUserCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

@end

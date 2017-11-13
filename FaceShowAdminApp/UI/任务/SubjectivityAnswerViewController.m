//
//  SubjectivityAnswerViewController.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SubjectivityAnswerViewController.h"
#import "SubjectivityAnswerCell.h"
#import "CourseCommentTitleView.h"
#import "CourseCommentHeaderView.h"
#import "GetSubjectivityAnswerListFetcher.h"

@interface SubjectivityAnswerViewController ()
@property (nonatomic, strong) GetSubjectivityAnswerItem *item;
@end

@implementation SubjectivityAnswerViewController

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    self.bNeedFooter = NO;
    GetSubjectivityAnswerListFetcher *fetcher = [[GetSubjectivityAnswerListFetcher alloc]init];
    fetcher.questionId = self.question.questionId;
    WEAK_SELF
    [fetcher setFinishBlock:^(GetSubjectivityAnswerItem *item){
        STRONG_SELF
        self.item = item;
    }];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"回复";
    self.emptyView.title = @"暂无评论";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *title = self.question.title;
    CGFloat height = [CourseCommentTitleView heightForTitle:title];
    CourseCommentTitleView *headerView = [[CourseCommentTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
    headerView.title = title;
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[SubjectivityAnswerCell class] forCellReuseIdentifier:@"SubjectivityAnswerCell"];
    [self.tableView registerClass:[CourseCommentHeaderView class] forHeaderFooterViewReuseIdentifier:@"CourseCommentHeaderView"];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectivityAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectivityAnswerCell"];
    cell.bottomLineHidden = indexPath.row==self.dataArray.count-1;
    cell.currentTime = self.item.currentTime;
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseCommentHeaderView"];
    header.countStr = [NSString stringWithFormat:@"%@", @(self.dataArray.count)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

@end

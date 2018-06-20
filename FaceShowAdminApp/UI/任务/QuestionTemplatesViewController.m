//
//  QuestionTemplatesViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QuestionTemplatesViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "ErrorView.h"
#import "QuestionTemplatesTableHeaderView.h"
#import "QuestionTemplatesCell.h"
#import "QuestionTemplatesHeaderView.h"
#import "GetQuestionTemplatesRequest.h"
#import "CreateQuestionGroupItem.h"
#import "UITableView+TemplateLayoutHeaderView.h"
#import "FSDefaultHeaderFooterView.h"
@interface QuestionTemplatesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) QuestionTemplatesTableHeaderView *tableHeaderView;
@property (nonatomic, strong) ErrorView *errorView;

@property (nonatomic, strong) GetQuestionTemplatesRequest *templatesRequest;
@property (nonatomic, strong) CreateQuestionGroupItem *itemData;
@end

@implementation QuestionTemplatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self requestForQuestionTemplate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set
- (void)setItemData:(CreateQuestionGroupItem *)itemData{
    _itemData = itemData;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    [self.tableHeaderView reloadQuestionTemplateTitle:itemData.title withTemplateContent:itemData.desc];
    if (itemData.desc.length > 0) {
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 66.0f + [QuestionTemplatesTableHeaderView calculateHeightBasedContent:itemData.desc] + 30.0f + 5.0f);
    }else {
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 66.0f);
    }
    self.tableView.tableHeaderView = self.tableHeaderView;
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 45.0f;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[QuestionTemplatesCell class] forCellReuseIdentifier:@"QuestionTemplatesCell"];
    [self.tableView registerClass:[QuestionTemplatesHeaderView class] forHeaderFooterViewReuseIdentifier:@"QuestionTemplatesHeaderView"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    self.tableHeaderView = [[QuestionTemplatesTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56.0f)];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.errorView = [[ErrorView alloc]init];
    self.errorView.hidden = YES;
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestForQuestionTemplate];
    }];
    [self.view addSubview:self.errorView];
    
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataScore
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemData.questions.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CreateQuestionGroupItem_Question *question = self.itemData.questions[section];
    return question.voteInfo.voteItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTemplatesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionTemplatesCell" forIndexPath:indexPath];
    CreateQuestionGroupItem_Question *question = self.itemData.questions[indexPath.section];
    CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = question.voteInfo.voteItems[indexPath.row];
    [cell reloadTemplate:item.itemName withType:question.questionType.integerValue];
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QuestionTemplatesHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QuestionTemplatesHeaderView"];
    CreateQuestionGroupItem_Question *question = self.itemData.questions[section];
    [headerView reloadTemplate:question.title withIndex:section+1 withType:question.questionType.integerValue];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    return footerView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"QuestionTemplatesCell" configuration:^(QuestionTemplatesCell *cell) {
        CreateQuestionGroupItem_Question *question = self.itemData.questions[indexPath.section];
        CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = question.voteInfo.voteItems[indexPath.row];
        [cell reloadTemplate:item.itemName withType:question.questionType.integerValue];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView yx_heightForHeaderWithIdentifier:@"QuestionTemplatesHeaderView" configuration:^(QuestionTemplatesHeaderView *header) {
        CreateQuestionGroupItem_Question *question = self.itemData.questions[section];
         [header reloadTemplate:question.title withIndex:section+1 withType:question.questionType.integerValue];
    }];
}
#pragma mark - request
- (void)requestForQuestionTemplate {
    [self.view nyx_startLoading];
    GetQuestionTemplatesRequest *request = [[GetQuestionTemplatesRequest alloc] init];
    request.templateId = self.templateId;
    WEAK_SELF
    [request startRequestWithRetClass:[GetQuestionTemplatesRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetQuestionTemplatesRequestItem *item = retItem;
        self.itemData = item.data;
    }];
    self.templatesRequest = request;
}
@end

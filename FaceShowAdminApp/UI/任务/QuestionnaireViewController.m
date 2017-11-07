//
//  QuestionnaireViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "ChooseQuestionResultCell.h"
#import "FillQuestionResultCell.h"
#import "GetVoteRequest.h"
#import "GetQuestionnaireRequest.h"
#import "QuestionRequestItem.h"
#import "ErrorView.h"
#import "QuestionnaireHeaderView.h"
#import "MJRefresh.h"

@interface QuestionnaireViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) GetVoteRequest *voteRequest;
@property (nonatomic, strong) GetQuestionnaireRequest *questionnaireRequest;
@property (nonatomic, strong) QuestionRequestItem *requestItem;
@property (nonatomic, strong) QuestionnaireHeaderView *headerView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@end

@implementation QuestionnaireViewController

- (void)dealloc {
    [self.header free];
}

- (instancetype)initWithStepId:(NSString *)stepId interactType:(InteractType)type {
    if (self = [super init]) {
        self.stepId = stepId;
        self.interactType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.interactType == InteractType_Vote) {
        self.navigationItem.title = @"投票详情";
    }else {
        self.navigationItem.title = @"问卷详情";
    }
    [self setupUI];
    [self requestPaperInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestPaperInfo {
    if (self.interactType == InteractType_Vote) {
        [self.voteRequest stopRequest];
        self.voteRequest = [[GetVoteRequest alloc]init];
        self.voteRequest.stepId = self.stepId;
        [self.view nyx_startLoading];
        WEAK_SELF
        [self.voteRequest startRequestWithRetClass:[QuestionRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.header endRefreshing];
            [self.view nyx_stopLoading];
            self.errorView.hidden = YES;
            if (error) {
                self.errorView.hidden = NO;
                return;
            }
            [self refreshUIWithItem:retItem];
        }];
    }else {
        [self.questionnaireRequest stopRequest];
        self.questionnaireRequest = [[GetQuestionnaireRequest alloc]init];
        self.questionnaireRequest.stepId = self.stepId;
        [self.view nyx_startLoading];
        WEAK_SELF
        [self.questionnaireRequest startRequestWithRetClass:[QuestionRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.header endRefreshing];
            [self.view nyx_stopLoading];
            self.errorView.hidden = YES;
            if (error) {
                self.errorView.hidden = NO;
                return;
            }
            [self refreshUIWithItem:retItem];
        }];
    }
}

- (void)refreshUIWithItem:(QuestionRequestItem *)item {
    self.requestItem = item;
    self.headerView.data = item.data;
    [self.tableView reloadData];
}

- (void)setupUI {
    self.headerView = [[QuestionnaireHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165)];
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[ChooseQuestionResultCell class] forCellReuseIdentifier:@"ChooseQuestionResultCell"];
    [self.tableView registerClass:[FillQuestionResultCell class] forCellReuseIdentifier:@"FillQuestionResultCell"];
    
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestPaperInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestPaperInfo];
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requestItem.data.questionGroup.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionRequestItem_question *question = self.requestItem.data.questionGroup.questions[indexPath.row];
    QuestionType type = [FSDataMappingTable QuestionTypeWithKey:question.questionType];
    if (type==QuestionType_SingleChoose || type==QuestionType_MultiChoose) {
        ChooseQuestionResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseQuestionResultCell"];
        cell.index = indexPath.row+1;
        cell.item = question;
        cell.bottomLineHidden = indexPath.row==self.requestItem.data.questionGroup.questions.count;
        return cell;
    }
    if (type == QuestionType_Fill) {
        FillQuestionResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FillQuestionResultCell"];
        cell.index = indexPath.row+1;
        cell.item = question;
        cell.bottomLineHidden = indexPath.row==self.requestItem.data.questionGroup.questions.count;
        WEAK_SELF
        [cell setShowReplyBlock:^{
            STRONG_SELF
        }];
        return cell;
    }
    return nil;
}

@end

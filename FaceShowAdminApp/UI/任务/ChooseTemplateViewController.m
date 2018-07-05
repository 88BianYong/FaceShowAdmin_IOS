//
//  ChooseTemplateViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ChooseTemplateViewController.h"
#import "GetQuestionGroupTemplatesRequest.h"
#import "CreateEvaluateHeaderView.h"
#import "CreateEvaluateCell.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "QuestionTemplatesViewController.h"
#import "ErrorView.h"
#import "EmptyView.h"
#import "GetQuestionTemplatesRequest.h"
@interface ChooseTemplateViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, strong) GetQuestionGroupTemplatesRequest *groupRequest;
@property (nonatomic, strong) GetQuestionGroupTemplatesRequestItem *itemData;
@property (nonatomic, assign) NSInteger chooseInteger;

@property (nonatomic, strong) GetQuestionTemplatesRequest *templatesRequest;
@end

@implementation ChooseTemplateViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择模板";
    [self setupUI];
    [self setupLayout];
    [self requestForQuestionGroupTemplates];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set
- (void)setItemData:(GetQuestionGroupTemplatesRequestItem *)itemData{
    _itemData = itemData;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    self.chooseInteger = -1;
    [self.itemData.data enumerateObjectsUsingBlock:^(GetQuestionGroupTemplatesRequestItem_Data *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.templateId isEqualToString:self.templateId]) {
            self.chooseInteger = idx;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chooseInteger inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setSelected:YES animated:YES];
            *stop = YES;
        }
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 45.0f;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CreateEvaluateCell class] forCellReuseIdentifier:@"CreateEvaluateCell"];
    [self.tableView registerClass:[CreateEvaluateHeaderView class] forHeaderFooterViewReuseIdentifier:@"CreateEvaluateHeaderView"];
    self.errorView = [[ErrorView alloc]init];
    self.errorView.hidden = YES;
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestForQuestionGroupTemplates];
    }];
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无可使用模板";
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];

    [self.view addSubview:self.errorView];
    [self setupNavigationRightView];
}
- (void)setupNavigationRightView{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self requestForQuestionTemplate];
    }];
    rightButton.enabled = NO;
    self.publishButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataScore
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemData.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateEvaluateCell" forIndexPath:indexPath];
    GetQuestionGroupTemplatesRequestItem_Data *data = self.itemData.data[indexPath.row];
    cell.titleString = data.title;
    cell.enabled = YES;
    WEAK_SELF
    cell.previewTemplateBlock = ^{
        STRONG_SELF
        QuestionTemplatesViewController *VC = [[QuestionTemplatesViewController alloc] init];
        VC.templateId = data.templateId;
        VC.navigationItem.title = data.title;
        [self.navigationController pushViewController:VC animated:YES];
    };
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.publishButton.enabled = YES;
    self.chooseInteger = indexPath.row;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CreateEvaluateHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CreateEvaluateHeaderView"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}
#pragma mark - request
- (void)requestForQuestionGroupTemplates {
    [self.view nyx_startLoading];
    GetQuestionGroupTemplatesRequest *request = [[GetQuestionGroupTemplatesRequest alloc] init];
    request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    request.interactType = self.interactType;
    WEAK_SELF
    [request startRequestWithRetClass:[GetQuestionGroupTemplatesRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetQuestionGroupTemplatesRequestItem *item = retItem;
        if (item.data.count == 0) {
            self.emptyView.hidden = NO;
            return;
        }
        self.itemData = retItem;
    }];
    self.groupRequest = request;
}
- (void)requestForQuestionTemplate {
    [self.view nyx_startLoading];
    GetQuestionGroupTemplatesRequestItem_Data *data = self.itemData.data[self.chooseInteger];
    GetQuestionTemplatesRequest *request = [[GetQuestionTemplatesRequest alloc] init];
    request.templateId = data.templateId;
    WEAK_SELF
    [request startRequestWithRetClass:[GetQuestionTemplatesRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:@"模板读取失败请重试"];
        }
        GetQuestionTemplatesRequestItem *item = retItem;
        BLOCK_EXEC(self.loadTemplateBlock,item.data);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.templatesRequest = request;
}
@end

//
//  CreateEvaluateViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateEvaluateViewController.h"
#import "GetQuestionGroupTemplatesRequest.h"
#import "CreateEvaluateHeaderView.h"
#import "CreateEvaluateCell.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "QuestionTemplatesViewController.h"
#import "ErrorView.h"
#import "CreateComplexRequest.h"
#import "TaskChooseContentView.h"
#import "SubordinateCourseViewController.h"
@interface CreateEvaluateViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) TaskChooseContentView *courseView;

@property (nonatomic, strong) ErrorView *errorView;

@property (nonatomic, strong) GetQuestionGroupTemplatesRequest *groupRequest;
@property (nonatomic, strong) GetQuestionGroupTemplatesRequestItem *itemData;
@property (nonatomic, strong) CreateComplexRequest *createRequest;

@property (nonatomic, assign) NSInteger chooseInteger;
@property (nonatomic, strong) NSString *courseId;


@end

@implementation CreateEvaluateViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新建评价";
    [self setupUI];
    [self setupLayout];
    [self requestForQuestionGroupTemplates];
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"确定" action:^{
        STRONG_SELF
        [self requestForCreateEvaluate];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set
- (void)setItemData:(GetQuestionGroupTemplatesRequestItem *)itemData{
    _itemData = itemData;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    self.chooseInteger = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chooseInteger inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 45.0f;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CreateEvaluateCell class] forCellReuseIdentifier:@"CreateEvaluateCell"];
    [self.tableView registerClass:[CreateEvaluateHeaderView class] forHeaderFooterViewReuseIdentifier:@"CreateEvaluateHeaderView"];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49.0f)];
    tableHeaderView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.tableHeaderView = tableHeaderView;
    self.courseView = [[TaskChooseContentView alloc] init];
    self.courseView.chooseContentString = [UserManager sharedInstance].userModel.currentClass.clazsName;
    WEAK_SELF
    self.courseView.pushSubordinateCourseBlock = ^{
        STRONG_SELF
        SubordinateCourseViewController *VC = [[SubordinateCourseViewController alloc] init];
        VC.courseId = self.courseId;
        VC.chooseSubordinateCoursBlock = ^(NSString *courseId,NSString *courseName) {
            if (courseId == nil) {
                self.courseView.chooseType = SubordinateCourse_Class;
                self.courseView.chooseContentString = [UserManager sharedInstance].userModel.currentClass.clazsName;
                self.courseId = nil;
            }else {
                self.courseView.chooseType = SubordinateCourse_Course;
                self.courseId = courseId;
                self.courseView.chooseContentString = courseName;
            }
        };
        [self.navigationController pushViewController:VC animated:YES];
    };
    [tableHeaderView addSubview:self.courseView];
    [self.courseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeaderView.mas_left);
        make.right.equalTo(tableHeaderView.mas_right);
        make.bottom.equalTo(tableHeaderView.mas_bottom);
        make.height.mas_offset(44.0f);
    }];
    self.errorView = [[ErrorView alloc]init];
    self.errorView.hidden = YES;
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestForQuestionGroupTemplates];
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemData.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateEvaluateCell" forIndexPath:indexPath];
    GetQuestionGroupTemplatesRequestItem_Data *data = self.itemData.data[indexPath.row];
    cell.titleString = data.title;
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
    WEAK_SELF
    [request startRequestWithRetClass:[GetQuestionGroupTemplatesRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        self.itemData = retItem;
    }];
    self.groupRequest = request;
}
- (void)requestForCreateEvaluate {
    GetQuestionGroupTemplatesRequestItem_Data *data = self.itemData.data[self.chooseInteger];
    CreateComplexRequest *request = [[CreateComplexRequest alloc] init];
    if (self.courseView.chooseType == SubordinateCourse_Course) {
        request.courseId = self.courseId;
    }else {
        request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    request.createType = CreateComplex_Evaluate;
    request.templateId = data.templateId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            BLOCK_EXEC(self.reloadComleteBlock);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.createRequest = request;
}
@end

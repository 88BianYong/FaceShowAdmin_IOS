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
#import "GetAllTasksRequest.h"
@interface CreateEvaluateViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) TaskChooseContentView *courseView;
@property (nonatomic, strong) UIButton *publishButton;
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
            [self.tableView reloadData];
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
        [self requestForCreateEvaluate];
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
    __block BOOL isCreatBool = NO;
    [self.templateIdMutableArray enumerateObjectsUsingBlock:^(GetAllTasksRequestItem_task *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((obj.templateId.integerValue == data.templateId.integerValue) && [self subordinateCourseIdForItem:obj]) {
            isCreatBool = YES;
            *stop = YES;
        }
    }];
    if (self.courseView.chooseType == SubordinateCourse_Class && data.templateType.integerValue != 1) {//班级下不允许选择课程模板
        isCreatBool = YES;
    }
    if (self.courseView.chooseType == SubordinateCourse_Course && data.templateType.integerValue == 1) {//课程下不允许选择班级模板
        isCreatBool = YES;
    }

    cell.enabled = !isCreatBool;
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
- (BOOL )subordinateCourseIdForItem:(GetAllTasksRequestItem_task *)item{
    if (self.courseView.chooseType == SubordinateCourse_Course) {
        return [self.courseId isEqualToString:item.courseId];
    }else {
        return [[UserManager sharedInstance].userModel.currentClass.clazsId isEqualToString:item.clazsId];
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateEvaluateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.enabled) {
        self.chooseInteger = indexPath.row;
        self.publishButton.enabled = YES;
    }else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chooseInteger inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [cell setSelected:YES animated:NO];
    }
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
    request.interactType = @"7";
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
            [self.view nyx_showToast:@"模板加载失败请重试"];
        }else {
            BLOCK_EXEC(self.reloadComleteBlock);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.createRequest = request;
}
@end

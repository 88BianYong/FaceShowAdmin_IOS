//
//  TaskViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskListCell.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "GetAllTasksRequest.h"
#import "FSDataMappingTable.h"
#import "MJRefresh.h"
#import "QuestionnaireViewController.h"
#import "SignInDetailRequest.h"
#import "SignInDetailViewController.h"
#import "YXDrawerController.h"
#import "AlertView.h"
#import "PublishTaskView.h"
#import "CreateWorkViewController.h"
#import "CreateComplexViewController.h"
#import "CreateCommentViewController.h"
#import "CreateSignInViewController.h"
#import "TaskFilterView.h"

@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) TaskFilterView *filterView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GetAllTasksRequest *request;
@property (nonatomic, strong) NSArray <GetAllTasksRequestItem_interactType *> *filterArray;
@property (nonatomic, strong) NSArray <GetAllTasksRequestItem_task *> *tasksArray;//任务列表所有数据
@property (nonatomic, strong) NSArray <GetAllTasksRequestItem_task *> *dataArray;//当前选中类型的任务数据
@property (nonatomic, strong) SignInDetailRequest *getSigninRequest;
@property (nonatomic, strong) SignInListRequestItem_signIns *signIn;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, assign) InteractType currentType;
@property (nonatomic, assign) BOOL isLayoutComplete;
@end

@implementation TaskViewController

- (void)dealloc {
    [self.header free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"抽屉列表按钮正常态" highlightImageName:@"抽屉列表按钮点击态" action:^{
        STRONG_SELF
        [YXDrawerController showDrawer];
    }];
    [self setupErrorView];
    [self setupObserver];
    [self requestTaskInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupErrorView {
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无任务";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestTaskInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

#pragma mark - setupUI
- (void)setupUI {
    self.filterView = [[TaskFilterView alloc]initWithDataArray:self.filterArray];
    WEAK_SELF
    [self.filterView setTaskFilterItemChooseBlock:^(GetAllTasksRequestItem_interactType *item) {
        STRONG_SELF
        self.currentType = [FSDataMappingTable InteractTypeWithKey:item.interactType];
        [self resetFilter];
    }];
    [self.view addSubview:self.filterView];
    NSInteger rowcount = ceilf(self.filterArray.count / 3.0);
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(95 * rowcount);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TaskListCell class] forCellReuseIdentifier:@"TaskListCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.filterView.mas_bottom).offset(5);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestTaskInfo];
    };
    [self nyx_setupRightWithTitle:@"发布任务" action:^{
        STRONG_SELF
        [self showAlertView];
    }];
}

- (void)requestTaskInfo {
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request stopRequest];
    self.request = [[GetAllTasksRequest alloc] init];
    self.request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
//    self.request.clazsId = @"9";
    [self.request startRequestWithRetClass:[GetAllTasksRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.header endRefreshing];
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetAllTasksRequestItem *item = (GetAllTasksRequestItem *)retItem;
        if (isEmpty(item.data.tasks)) {
            self.emptyView.hidden = NO;
            return;
        }
        self.tasksArray = [NSArray arrayWithArray:item.data.tasks];
        self.filterArray = [NSArray arrayWithArray:item.data.interactTypes];
        self.dataArray = [self filterWithType:self.currentType];
        if (!self.isLayoutComplete) {
            [self setupUI];
            self.currentType = InteractType_SignIn;
            [self resetFilter];
            self.isLayoutComplete = YES;
        }else {
            self.filterView.dataArray = self.filterArray;
        }
        self.filterView.selectedIndex = [self indexForInteractType:self.currentType];
        [self.tableView reloadData];
    }];
}

#pragma mark - filter
- (void)resetFilter {
    self.dataArray = [self filterWithType:self.currentType];
    [self.tableView reloadData];
}

- (NSArray *)filterWithType:(InteractType)type {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < self.tasksArray.count; i++) {
        GetAllTasksRequestItem_task *task = self.tasksArray[i];
        InteractType taskType = [FSDataMappingTable InteractTypeWithKey:task.interactType];
        if (taskType == type) {
            [resultArray addObject:task];
        }
    }
    return resultArray;
}

- (NSInteger)indexForInteractType:(InteractType)type {
    __block NSInteger index = 0;
    WEAK_SELF
    [self.filterArray enumerateObjectsUsingBlock:^(GetAllTasksRequestItem_interactType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF
        if ([FSDataMappingTable InteractTypeWithKey:obj.interactType] == type) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

#pragma mark - alert
- (void)showAlertView {
    PublishTaskView *taskView = [[PublishTaskView alloc] init];
    self.alertView = [[AlertView alloc]init];
    self.alertView.backgroundColor = [UIColor clearColor];
    self.alertView.hideWhenMaskClicked = YES;
    self.alertView.contentView = taskView;
    WEAK_SELF
    [self.alertView setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [taskView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_bottom);
                make.height.mas_offset(205.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [self.alertView showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [taskView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.top.equalTo(view.mas_bottom);
            make.height.mas_offset(205.0f );
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [taskView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(view.mas_safeAreaLayoutGuideBottom);
                    } else {
                        make.bottom.mas_equalTo(0);
                    }
                    make.height.mas_offset(205.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    taskView.publishTaskBlock = ^(NSInteger type) {
        STRONG_SELF
        [self.alertView hide];
        switch (type) {
            case 0:
            {
                CreateSignInViewController *vc = [[CreateSignInViewController alloc]init];
                WEAK_SELF
                [vc setComleteBlock:^{
                    STRONG_SELF
                    //[self firstPageFetch];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                CreateWorkViewController *VC = [[CreateWorkViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 2:
            {
                CreateCommentViewController *VC = [[CreateCommentViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
                
            default:
            {
                CreateComplexViewController *VC = [[CreateComplexViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
        }
    };
}
#pragma mark - Observer
- (void)setupObserver {
//    WEAK_SELF
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kReloadSignInRecordNotification" object:nil] subscribeNext:^(NSNotification *x) {
//        STRONG_SELF
//        NSDictionary *dic = (NSDictionary *)x.object;
//        NSIndexPath *currentIndex = [dic objectForKey:@"kSignInRecordCurrentIndexPath"];
//        //        NSString *signInTime = [dic valueForKey:@"kCurrentIndexPathSucceedSigninTime"];
//        //        GetSignInRecordListRequestItem_SignIn *signIn = self.signIn;
//        //        GetSignInRecordListRequestItem_UserSignIn *userSignIn = [GetSignInRecordListRequestItem_UserSignIn new];
//        //        userSignIn.signinTime = signInTime;
//        //        signIn.userSignIn = userSignIn;
//        GetTaskRequestItem_Task *task = self.dataArray[currentIndex.row];
//        task.stepFinished = @"1";
//        [self.tableView reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
//    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskListCell"];
    cell.data = self.dataArray[indexPath.row];
    cell.lineHidden = indexPath.row==self.dataArray.count-1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetAllTasksRequestItem_task *task = self.dataArray[indexPath.row];
    InteractType type = [FSDataMappingTable InteractTypeWithKey:task.interactType];
    if (type == InteractType_Vote || type == InteractType_Questionare) {
        QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:task.stepId interactType:type];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == InteractType_SignIn) {
        [self.getSigninRequest stopRequest];
        self.getSigninRequest = [[SignInDetailRequest alloc]init];
        self.getSigninRequest.stepId = task.stepId;
        WEAK_SELF
        [self.view nyx_startLoading];
        [self.getSigninRequest startRequestWithRetClass:[SignInDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error) {
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            SignInDetailRequestItem *item = retItem;
            SignInDetailViewController *signInDetailVC = [[SignInDetailViewController alloc] init];
            item.data.signIn.stepId = task.stepId;
            signInDetailVC.data = item.data.signIn;
            [self.navigationController pushViewController:signInDetailVC animated:YES];
        }];
    }
}

@end

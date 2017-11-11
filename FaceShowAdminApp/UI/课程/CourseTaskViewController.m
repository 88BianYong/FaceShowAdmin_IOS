//
//  CourseTaskViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTaskViewController.h"
#import "CourseTaskCell.h"
#import "FSDataMappingTable.h"
#import "QuestionnaireViewController.h"
#import "CourseCommentViewController.h"
#import "SignInDetailRequest.h"
#import "SignInDetailViewController.h"

@interface CourseTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SignInDetailRequest *request;
@end

@implementation CourseTaskViewController

- (void)viewDidLoad {
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

- (void)setInteractSteps:(NSArray<GetCourseRequestItem_InteractStep,Optional> *)interactSteps {
    _interactSteps = interactSteps;
    [self.tableView reloadData];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseTaskCell class] forCellReuseIdentifier:@"CourseTaskCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.interactSteps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTaskCell"];
    cell.data = self.interactSteps[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetCourseRequestItem_InteractStep *task = self.interactSteps[indexPath.row];
    InteractType type = [FSDataMappingTable InteractTypeWithKey:task.interactType];
    if (type == InteractType_Vote || type == InteractType_Questionare) {
        QuestionnaireViewController *vc = [[QuestionnaireViewController alloc]initWithStepId:task.stepId interactType:type];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == InteractType_Comment) {
        CourseCommentViewController *vc = [[CourseCommentViewController alloc]initWithStepId:task.stepId];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == InteractType_SignIn) {
        [self.request stopRequest];
        self.request = [[SignInDetailRequest alloc]init];
        self.request.stepId = task.stepId;
        WEAK_SELF
        [self.view nyx_startLoading];
        [self.request startRequestWithRetClass:[SignInDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
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

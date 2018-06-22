//
//  HomeworkDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HomeworkDetailViewController.h"
#import "HomeworkDetailHeaderView.h"
#import "SignInTabContainerView.h"
#import "HomeworkRequirementViewController.h"
#import "SubmittedHomeworkMemberListViewController.h"
#import "UnsubmittedHomeworkMemberListViewController.h"
#import "GetHomeworkRequest.h"

@interface HomeworkDetailViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@property (nonatomic, strong) HomeworkDetailHeaderView *headerView;
@end

@implementation HomeworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"作业详情";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    HomeworkDetailHeaderView *headerView = [[HomeworkDetailHeaderView alloc]init];
    self.headerView = headerView;
    self.headerView.data = self.item.data;
    WEAK_SELF
    [headerView setClickBlock:^{
        STRONG_SELF
        HomeworkRequirementViewController *vc = [[HomeworkRequirementViewController alloc]init];
        vc.data = self.item.data;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(175);
    }];
    SignInTabContainerView *tabContainerView = [[SignInTabContainerView alloc]init];
    tabContainerView.tabNameArray = @[@"已提交",@"未提交"];
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        [self switchToVCWithIndex:index];
    }];
    [self.view addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(headerView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(40);
    }];
    
    NSString *stepId = self.item.data.stepId;
    self.tabControllers = [NSMutableArray array];
    SubmittedHomeworkMemberListViewController *submittedVC = [[SubmittedHomeworkMemberListViewController alloc]init];
    submittedVC.stepId = stepId;
    UnsubmittedHomeworkMemberListViewController *unsubmittedVC = [[UnsubmittedHomeworkMemberListViewController alloc]init];
    unsubmittedVC.stepId = stepId;
    [self.tabControllers addObject:submittedVC];
    [self.tabControllers addObject:unsubmittedVC];
    for (UIViewController *vc in self.tabControllers) {
        [self addChildViewController:vc];
    }
    self.tabContentView = [[UIView alloc]init];
    [self.view addSubview:self.tabContentView];
    [self.tabContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(tabContainerView.mas_bottom);
    }];
    [self switchToVCWithIndex:0];
}

- (void)switchToVCWithIndex:(NSInteger)index {
    for (UIView *v in self.tabContentView.subviews) {
        [v removeFromSuperview];
    }
    UIView *v = self.tabControllers[index].view;
    [self.tabContentView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end

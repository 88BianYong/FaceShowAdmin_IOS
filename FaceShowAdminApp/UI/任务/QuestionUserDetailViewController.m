//
//  QuestionUserDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionUserDetailViewController.h"
#import "QuestionTabContainerView.h"
#import "QuestionUserListViewController.h"
#import "FSDataMappingTable.h"

@interface QuestionUserDetailViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@end

@implementation QuestionUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *prefix = @"";
    InteractType type = [FSDataMappingTable InteractTypeWithKey:self.data.interactType];
    if (type == InteractType_Vote) {
        prefix = @"投票人数：";
    } else if (type == InteractType_Questionare) {
        prefix = @"提交人数：";
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@/%@",prefix,self.data.questionGroup.answerUserNum,self.data.questionGroup.totalUserNum];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    InteractType type = [FSDataMappingTable InteractTypeWithKey:self.data.interactType];
    if (type == InteractType_Vote) {
        [TalkingData trackPageBegin:@"投票任务完成详情"];
    }else {
        [TalkingData trackPageBegin:@"问卷任务完成详情"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    InteractType type = [FSDataMappingTable InteractTypeWithKey:self.data.interactType];
    if (type == InteractType_Vote) {
        [TalkingData trackPageEnd:@"投票任务完成详情"];
    }else {
        [TalkingData trackPageEnd:@"问卷任务完成详情"];
    }
}

- (void)setupUI {
    QuestionTabContainerView *tabContainerView = [[QuestionTabContainerView alloc]init];
    tabContainerView.tabNameArray = @[@"已提交",@"未提交"];
    WEAK_SELF
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        [self switchToVCWithIndex:index];
    }];
    [self.view addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    self.tabControllers = [NSMutableArray array];
    QuestionUserListViewController *completeVC = [[QuestionUserListViewController alloc]init];
    completeVC.stepId = self.data.questionGroup.stepId;
    completeVC.status = @"1";
    QuestionUserListViewController *uncompleteVC = [[QuestionUserListViewController alloc]init];
    uncompleteVC.stepId = self.data.questionGroup.stepId;
    uncompleteVC.status = @"0";
    [self.tabControllers addObject:completeVC];
    [self.tabControllers addObject:uncompleteVC];
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

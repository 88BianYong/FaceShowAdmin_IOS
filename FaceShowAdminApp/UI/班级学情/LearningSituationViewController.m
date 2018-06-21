//
//  LearningSituationViewController.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "LearningSituationViewController.h"
#import "ScoreDefineViewController.h"
#import "ScroeDetailTabContainerView.h"
#import "TaskRankingViewController.h"
#import "ScoreRankingViewController.h"
#import "RefreshDelegate.h"

@interface LearningSituationViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController<RefreshDelegate> *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@property (nonatomic, strong) NSString *clazsId;
@end

@implementation LearningSituationViewController

- (instancetype)initWithClazsId:(NSString *)clazsId {
    if (self = [super init]) {
        self.clazsId = clazsId;
        [self setupUI];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级学情";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI {
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"积分设置" action:^{
        STRONG_SELF
        ScoreDefineViewController *vc = [[ScoreDefineViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    ScroeDetailTabContainerView *tabContainerView = [[ScroeDetailTabContainerView alloc]init];
    NSArray *tabNames = @[@"任务进度",@"学习积分"];
    tabContainerView.tabNameArray = tabNames;
    [tabContainerView setTabClickBlock:^(NSInteger index){
        STRONG_SELF
        self.selectedIndex = index;
        [self switchToVCWithIndex:index];
    }];
    [self.view addSubview:tabContainerView];
    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    self.tabControllers = [NSMutableArray array];
    [self.tabControllers addObject:[[TaskRankingViewController alloc]init]];
    [self.tabControllers addObject:[[ScoreRankingViewController alloc]init]];
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
    SAFE_CALL(self.tabControllers[index], refreshUI);
}

@end


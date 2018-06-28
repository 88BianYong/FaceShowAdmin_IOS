//
//  LearningSituationViewController.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "LearningSituationViewController.h"
#import "ClassRankViewController.h"
#import "LearningSituationView.h"
#import "GetCountClazsRequest.h"
#import "ErrorView.h"

@interface LearningSituationViewController ()
@property (nonatomic, strong) LearningSituationView *situationView;
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) UIButton *enterClassButton;
@property (nonatomic, strong) GetCountClazsRequest *clazsRequest;
@property (nonatomic, strong) ErrorView *errorView;
@end

@implementation LearningSituationViewController

- (instancetype)initWithClazsId:(NSString *)clazsId {
    if (self = [super init]) {
        self.clazsId = clazsId;
        [self requestClassDetail];
        [self setupUI];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学情排名";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.enterClassButton = [[UIButton alloc]init];
    self.enterClassButton.backgroundColor = [UIColor whiteColor];
    [self.enterClassButton setTitle:@"查看学员学情排名" forState:UIControlStateNormal];
    [self.enterClassButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    self.enterClassButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.enterClassButton addTarget:self action:@selector(enterClass) forControlEvents:UIControlEventTouchUpInside];
    self.enterClassButton.clipsToBounds = YES;
    [self.view addSubview:self.enterClassButton];
    [self.enterClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    self.situationView = [[LearningSituationView alloc]init];
    [self.view addSubview:self.situationView];
    [self.situationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.enterClassButton.mas_top).offset(-5);
    }];
    
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestClassDetail];
    }];
}

- (void)enterClass {
    ClassRankViewController *vc = [[ClassRankViewController alloc]initWithClazsId:self.clazsId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestClassDetail {
    [self.clazsRequest stopRequest];
    self.clazsRequest = [[GetCountClazsRequest alloc]init];
    self.clazsRequest.clazsId = self.clazsId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.clazsRequest startRequestWithRetClass:[GetCountClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        [self.errorView removeFromSuperview];
        GetCountClazsRequestItem *item = (GetCountClazsRequestItem *)retItem;
        self.situationView.item = item;
    }];
}

@end


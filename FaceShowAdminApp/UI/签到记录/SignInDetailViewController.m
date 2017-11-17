//
//  SignInDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInDetailViewController.h"
#import "SignInDetailHeaderView.h"
#import "SignInTabContainerView.h"
#import "SignedMemberListViewController.h"
#import "UnsignedMemberListViewController.h"
#import "SignInDetailRequest.h"
#import "QRCodeSignInViewController.h"
#import "DeleteStepRequest.h"

@interface SignInDetailViewController ()
@property (nonatomic, strong) NSMutableArray<UIViewController *> *tabControllers;
@property (nonatomic, strong) UIView *tabContentView;
@property (nonatomic, strong) SignInDetailRequest *detailRequest;
@property (nonatomic, strong) SignInDetailHeaderView *headerView;
@property (nonatomic, strong) DeleteStepRequest *deleteRequest;
@end

@implementation SignInDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"签到详情";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"删除" action:^{
        STRONG_SELF
        [self deleteSignIn];
    }];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteSignIn {
    [self.deleteRequest stopRequest];
    self.deleteRequest = [[DeleteStepRequest alloc]init];
    self.deleteRequest.stepId = self.data.stepId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.deleteRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view.window nyx_showToast:@"删除成功"];
        BLOCK_EXEC(self.deleteBlock);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kReplenishSignInDidSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshDetail];
    }];
}

- (void)refreshDetail {
    [self.detailRequest stopRequest];
    self.detailRequest = [[SignInDetailRequest alloc]init];
    self.detailRequest.stepId = self.data.stepId;
    WEAK_SELF
    [self.detailRequest startRequestWithRetClass:[SignInDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            return;
        }
        SignInDetailRequestItem *item = (SignInDetailRequestItem *)retItem;
        self.headerView.data = item.data.signIn;
    }];
}

- (void)setupUI {
    SignInDetailHeaderView *headerView = [[SignInDetailHeaderView alloc]init];
    self.headerView = headerView;
    headerView.data = self.data;
    WEAK_SELF
    [headerView setQrBlock:^{
        STRONG_SELF
        [TalkingData trackEvent:@"查看签到二维码"];
        QRCodeSignInViewController *vc = [[QRCodeSignInViewController alloc]init];
        vc.data = self.data;
        WEAK_SELF
        [vc setBackBlock:^{
            STRONG_SELF
            [self refreshDetail];
            UnsignedMemberListViewController *unsignedVC = (UnsignedMemberListViewController *)self.tabControllers.firstObject;
            [unsignedVC firstPageFetch];
            SignedMemberListViewController *signedVC = (SignedMemberListViewController *)self.tabControllers.lastObject;
            [signedVC firstPageFetch];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(175);
    }];
    SignInTabContainerView *tabContainerView = [[SignInTabContainerView alloc]init];
    tabContainerView.tabNameArray = @[@"未签到",@"已签到"];
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
    self.tabControllers = [NSMutableArray array];
    SignedMemberListViewController *signedVC = [[SignedMemberListViewController alloc]init];
    signedVC.stepId = self.data.stepId;
    UnsignedMemberListViewController *unsignedVC = [[UnsignedMemberListViewController alloc]init];
    unsignedVC.stepId = self.data.stepId;
    [self.tabControllers addObject:unsignedVC];
    [self.tabControllers addObject:signedVC];
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

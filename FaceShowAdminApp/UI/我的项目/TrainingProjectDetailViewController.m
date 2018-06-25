//
//  TrainingProjectDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TrainingProjectDetailViewController.h"
#import "ProjectDetailStatisticItemView.h"
#import "ClassSwitchView.h"
#import "ClassInfoView.h"
#import "QASlideView.h"
#import "ProjectDetailRequest.h"
#import "ErrorView.h"

@interface TrainingProjectDetailViewController ()<QASlideViewDelegate,QASlideViewDataSource>
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *statisticLabel;
@property (nonatomic, strong) ProjectDetailStatisticItemView *completeView;
@property (nonatomic, strong) ProjectDetailStatisticItemView *scoreView;
@property (nonatomic, strong) ClassSwitchView *switchView;
@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) UIButton *enterClassButton;
@property (nonatomic, strong) ProjectDetailRequest *detailRequest;
@property (nonatomic, strong) ProjectDetailRequestItem *requestItem;
@property (nonatomic, strong) ErrorView *errorView;
@end

@implementation TrainingProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self requestProjectDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"蓝色背景"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(180);
    }];
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(0);
    }];
    self.completeView = [[ProjectDetailStatisticItemView alloc]init];
    self.completeView.name = @"任务完成度";
    [bgView addSubview:self.completeView];
    [self.completeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(bgView.mas_centerX).multipliedBy(0.5);
    }];
    self.scoreView = [[ProjectDetailStatisticItemView alloc]init];
    self.scoreView.name = @"平均积分";
    [bgView addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.completeView.mas_top);
        make.centerX.mas_equalTo(bgView.mas_centerX).multipliedBy(1.5);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"539dd3"];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.completeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.12];
    [bgView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.statisticLabel = [[UILabel alloc]init];
    self.statisticLabel.font = [UIFont systemFontOfSize:14];
    self.statisticLabel.textColor = [UIColor whiteColor];
    self.statisticLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:self.statisticLabel];
    [self.statisticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    self.switchView = [[ClassSwitchView alloc]init];
    WEAK_SELF
    [self.switchView setPreBlock:^{
        STRONG_SELF
        [self.slideView scrollToItemIndex:self.slideView.currentIndex-1 animated:YES];
    }];
    [self.switchView setNextBlock:^{
        STRONG_SELF
        [self.slideView scrollToItemIndex:self.slideView.currentIndex+1 animated:YES];
    }];
    [self.view addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(63);
    }];
    self.enterClassButton = [[UIButton alloc]init];
    self.enterClassButton.backgroundColor = [UIColor whiteColor];
    [self.enterClassButton setTitle:@"进入班级" forState:UIControlStateNormal];
    [self.enterClassButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    self.enterClassButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.enterClassButton addTarget:self action:@selector(enterClass) forControlEvents:UIControlEventTouchUpInside];
    self.enterClassButton.clipsToBounds = YES;
    [self.view addSubview:self.enterClassButton];
    
    self.slideView = [[QASlideView alloc]init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    [self.view addSubview:self.slideView];
    [self.enterClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchView.mas_bottom);
        make.bottom.mas_equalTo(self.enterClassButton.mas_top).mas_offset(-5);
        make.left.right.mas_equalTo(0);
    }];
    
    for (UIView *v in self.view.subviews) {
        v.hidden = YES;
    }
    
    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestProjectDetail];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

- (void)enterClass {
    ProjectDetailRequestItem_clazs *clazs = self.requestItem.data.clazses[self.slideView.currentIndex];
    ClassListRequestItem_clazsInfos *clazsInfo = [[ClassListRequestItem_clazsInfos alloc]init];
    clazsInfo.clazsName = clazs.clazsName;
    clazsInfo.clazsId = clazs.clazsId;
    clazsInfo.platId = clazs.platId;
    clazsInfo.projectId = clazs.projectId;
    [UserManager sharedInstance].userModel.currentClass = clazsInfo;
    [[UserManager sharedInstance] saveData];
    [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
}

- (void)requestProjectDetail {
    [self.view nyx_startLoading];
    [self.detailRequest stopRequest];
    self.detailRequest = [[ProjectDetailRequest alloc]init];
    self.detailRequest.projectId = self.projectId;
    WEAK_SELF
    [self.detailRequest startRequestWithRetClass:[ProjectDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        for (UIView *v in self.view.subviews) {
            v.hidden = NO;
        }
        self.errorView.hidden = YES;
        [self refreshUIWithItem:retItem];
    }];
}

- (void)refreshUIWithItem:(ProjectDetailRequestItem *)item {
    self.requestItem = item;
    self.navigationItem.title = item.data.projectCount.projectName;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",[item.data.projectCount.startTime substringToIndex:10],[item.data.projectCount.endTime substringToIndex:10]];
    self.completeView.number = [NSString stringWithFormat:@"%.0f%@",item.data.projectCount.taskFinishedRate.floatValue*100,@"%"];
    self.scoreView.number = item.data.projectCount.projectLikedRate;
    self.statisticLabel.text = [NSString stringWithFormat:@"班级  %@     学员  %@     班主任  %@",item.data.projectCount.clazsNum,item.data.projectCount.studentNum,item.data.projectCount.masterNum];
    if (self.requestItem.data.clazses.count > 0) {
        [self.slideView reloadData];
    }else {
        self.switchView.hidden = YES;
        self.enterClassButton.hidden = YES;
    }
}

#pragma mark - QASlideViewDataSource
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.requestItem.data.clazses.count;
}
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    ClassInfoView *infoView = [[ClassInfoView alloc]init];
    ProjectDetailRequestItem_clazs *clazs = self.requestItem.data.clazses[index];
    infoView.clazsId = clazs.clazsId;
    return infoView;
}
#pragma mark - QASlideViewDelegate
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    ProjectDetailRequestItem_clazs *clazs = self.requestItem.data.clazses[to];
    self.switchView.className = clazs.clazsName;
    [self.switchView resetPreNext];
    if (to == 0) {
        [self.switchView reachFirst];
    }
    if (to == self.requestItem.data.clazses.count-1) {
        [self.switchView reachLast];
    }
}
@end

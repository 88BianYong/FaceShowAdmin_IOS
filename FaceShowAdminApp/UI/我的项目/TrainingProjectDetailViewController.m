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

@interface TrainingProjectDetailViewController ()<QASlideViewDelegate,QASlideViewDataSource>
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *statisticLabel;
@property (nonatomic, strong) ProjectDetailStatisticItemView *completeView;
@property (nonatomic, strong) ProjectDetailStatisticItemView *scoreView;
@property (nonatomic, strong) ClassSwitchView *switchView;
@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) UIButton *enterClassButton;
@end

@implementation TrainingProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"湖北高级教师骨干项目";
    [self setupUI];
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
    self.slideView = [[QASlideView alloc]init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    [self.view addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchView.mas_bottom);
        make.bottom.mas_equalTo(self.enterClassButton.mas_top).mas_offset(-5);
        make.left.right.mas_equalTo(0);
    }];
    
    // mock mock
    self.completeView.number = @"80%";
    self.scoreView.number = @"75";
    self.dateLabel.text = @"2017.3.4 - 2017.6.23";
    self.statisticLabel.text = [NSString stringWithFormat:@"班级  %@     学员  %@     班主任  %@",@(5),@(125),@(10)];
//    self.switchView.className = @"骨干面授一般";
}

- (void)enterClass {
    
}

#pragma mark - QASlideViewDataSource
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return 10;
}
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    ClassInfoView *infoView = [[ClassInfoView alloc]init];
    return infoView;
}
#pragma mark - QASlideViewDelegate
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    self.switchView.className = [NSString stringWithFormat:@"面授骨干%@班",@(to+1)];
    [self.switchView resetPreNext];
    if (to == 0) {
        [self.switchView reachFirst];
    }
    if (to == 10-1) {
        [self.switchView reachLast];
    }
}
@end

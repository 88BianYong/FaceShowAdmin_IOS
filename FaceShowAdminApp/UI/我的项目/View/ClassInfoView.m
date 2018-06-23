//
//  ClassInfoView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassInfoView.h"
#import "ClassStatisticView.h"
#import "ClassDetailStatisticView.h"
#import "GetCountClazsRequest.h"

@interface ClassInfoView ()
@property (nonatomic, strong) ClassStatisticView *statisticView;
@property (nonatomic, strong) ClassDetailStatisticView *detailStatisticView;
@property (nonatomic, strong) GetCountClazsRequest *clazsRequest;
@end

@implementation ClassInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.alwaysBounceVertical = YES;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIView *contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(scrollView.mas_width);
    }];
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.statisticView = [[ClassStatisticView alloc]init];
    [contentView addSubview:self.statisticView];
    [self.statisticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(84);
        make.top.mas_equalTo(line1.mas_bottom);
    }];
    UIView *line2 = [line1 clone];
    [contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.statisticView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.detailStatisticView = [[ClassDetailStatisticView alloc]init];
    [contentView addSubview:self.detailStatisticView];
    [self.detailStatisticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(line2.mas_bottom);
    }];
}

- (void)setClazsId:(NSString *)clazsId {
    _clazsId = clazsId;
    [self nyx_startLoading];
    [self.clazsRequest stopRequest];
    self.clazsRequest = [[GetCountClazsRequest alloc]init];
    self.clazsRequest.clazsId = self.clazsId;
    WEAK_SELF
    [self.clazsRequest startRequestWithRetClass:[GetCountClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self nyx_stopLoading];
        if (error) {
            [self nyx_showToast:error.localizedDescription];
            return;
        }
        GetCountClazsRequestItem *item = (GetCountClazsRequestItem *)retItem;
        self.statisticView.data = item.data;
        self.detailStatisticView.data = item.data;
    }];
}

@end

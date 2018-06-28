//
//  LearningSituationView.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "LearningSituationView.h"
#import "ClassStatisticView.h"
#import "ClassDetailStatisticView.h"
#import "GetCountClazsRequest.h"

@interface LearningSituationView ()
@property (nonatomic, strong) ClassStatisticView *statisticView;
@property (nonatomic, strong) ClassDetailStatisticView *detailStatisticView;
@end

@implementation LearningSituationView

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

- (void)setItem:(GetCountClazsRequestItem *)item {
    _item = item;
    self.statisticView.data = item.data;
    self.detailStatisticView.data = item.data;
}

@end

